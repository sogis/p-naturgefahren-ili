# Evaluation Problem Referenz-Stabilität Prozessquelle-Teilauftrag

Im Zusammenhang mit Aspekten des Datenflusses wurde die folgende Fragestellung untersucht:
* Ist es möglich, die Daten so auszutauschen, dass trotz instabilen Objektidentifikatoren das Basket der Befunddaten mit Referenz zum Teilauftrag gültig übernommen werden kann?

## Variante 1: Mit einseitigem Referenzattribut

Idee: Einseitiges Referenzattribut über eine Struktur

```
    STRUCTURE Ref =
      Teilauftrag: MANDATORY REFERENCE TO (EXTERNAL) SO_AFU_Naturgefahren_20220801.Auftraege.TeilauftragRaumbezug;
    END Ref;

    /** Beschreibung der Prozessquelle */
    CLASS Prozessquelle =
      /** Name der Prozessquelle (Dorfbach) */
      ProzessquellenName : MANDATORY TEXT*80;
      Hauptprozess : MANDATORY Hauptprozess;
      Ref : MANDATORY Ref;
    END Prozessquelle;
```

```

<Ref><SO_AFU_Naturgefahren_20220801.Befunde.Ref><Teilauftrag REF="6a38b76b-beca-45b9-84a0-8d2579c61107"></Teilauftrag>
```

Fazit: Keine Option, das REF-Attribut genau gleich an der Prozessquelle hängt.


## Variante 2: Mit Proxy-Klasse in separatem Topic

Idee: Proxy-Klasse (in sep. Topic) enthält ein Eintrag pro Zuordnung zwischen Teilauftrag und Prozessquelle


```
TOPIC AssocProxy =
    DEPENDS ON Auftraege, Befunde;
    ASSOCIATION TeilauftragProzessquelle =
      TeilauftragProzessquelle (EXTERNAL) -- {0..1} SO_AFU_Naturgefahren_20220801.Befunde.Prozessquelle;
      ProzessquelleTeilauftrag (EXTERNAL) -- {1} SO_AFU_Naturgefahren_20220801.Auftraege.TeilauftragRaumbezug;
    END TeilauftragProzessquelle;
  END AssocProxy;
```

```xml
<SO_AFU_Naturgefahren_20220801.Auftraege BID="SO_AFU_Naturgefahren_20220801.Auftraege">
<SO_AFU_Naturgefahren_20220801.Auftraege.Auftrag TID="00ea5ed8-5634-422c-be68-f79565cb1647"><Name>BSB.2022.1</Name><Fachstelle>FS1</Fachstelle><Deklaration>Neubeurteilung</Deklaration></SO_AFU_Naturgefahren_20220801.Auftraege.Auftrag>
<SO_AFU_Naturgefahren_20220801.Auftraege.TeilauftragRutschSturz TID="c911d5da-8f02-493b-8299-dd71eb756d92"><Name>BSB.2022.1.1</Name><Geometrie><SURFACE><BOUNDARY><POLYLINE><COORD><C1>2697789.957</C1><C2>1202457.538</C2></COORD><COORD><C1>2755139.194</C1><C2>1247859.017</C2></COORD><COORD><C1>2785672.352</C1><C2>1204050.573</C2></COORD><COORD><C1>2733633.230</C1><C2>1148028.865</C2></COORD><COORD><C1>2697789.957</C1><C2>1202457.538</C2></COORD></POLYLINE></BOUNDARY></SURFACE></Geometrie><TeilauftragAuftrag REF="00ea5ed8-5634-422c-be68-f79565cb1647"></TeilauftragAuftrag><Grundszenarien>false</Grundszenarien><Jaehrlichkeit>55</Jaehrlichkeit><Teilprozess>Hangmure</Teilprozess></SO_AFU_Naturgefahren_20220801.Auftraege.TeilauftragRutschSturz>
</SO_AFU_Naturgefahren_20220801.Auftraege>

<SO_AFU_Naturgefahren_20220801.Befunde BID="SO_AFU_Naturgefahren_20220801.Befunde">
<SO_AFU_Naturgefahren_20220801.Befunde.Prozessquelle TID="326dde20-9203-4344-a302-58082164632d"><ProzessquellenName>PQ1</ProzessquellenName><Hauptprozess>Absenkung_Einsturz</Hauptprozess></SO_AFU_Naturgefahren_20220801.Befunde.Prozessquelle>
</SO_AFU_Naturgefahren_20220801.Befunde>

<SO_AFU_Naturgefahren_20220801.AssocProxy BID="SO_AFU_Naturgefahren_20220801.AssocProxy">
<SO_AFU_Naturgefahren_20220801.AssocProxy.TeilauftragProzessquelle><TeilauftragProzessquelle REF="326dde20-9203-4344-a302-58082164632d"></TeilauftragProzessquelle><ProzessquelleTeilauftrag REF="c911d5da-8f02-493b-8299-dd71eb756d92"></ProzessquelleTeilauftrag></SO_AFU_Naturgefahren_20220801.AssocProxy.TeilauftragProzessquelle>
</SO_AFU_Naturgefahren_20220801.AssocProxy>
```

Fazit:
1. PG-Export mit allen drei Topics
2. Import mit instabilen OIDs
=> Gleiche Problematik wie Variante 1


## Variante 3: Mit geometrischem Bezug (DERIVED FROM) und Zusammenzug in View

Idee: Kein attributiver Bezug, sondern geometrischer bezug zwischen Teilauftrags-Abklärungsperimeter und einer Befundsflaeche. 
(eine fachliche Diskussion dieses Zusammenhangs ist nicht erfolgt)

```
TOPIC AssocProxy =

    DEPENDS ON Auftraege, Befunde;

    VIEW ProzQBefd
      JOIN OF 
        Pq ~ SO_AFU_Naturgefahren_20220801.Befunde.Prozessquelle,
        Bf ~ SO_AFU_Naturgefahren_20220801.Befunde.Befund;
      WHERE (Pq==Bf);
      =
      Geometrie: Einzelflaeche := Bf -> Geometrie;
    END ProzQBefd;

    VIEW BefundeInTeilauftrag
    JOIN OF 
      PqBf ~ ProzQBefd,
      TaRb ~ SO_AFU_Naturgefahren_20220801.Auftraege.TeilauftragRaumbezug;
    WHERE NGK_FunctionsExt.IsContainedBy(TaRb -> Geometrie, PqBf -> Geometrie);
    =
    END BefundeInTeilauftrag;
   
    ASSOCIATION TeilauftragsObjekte
      DERIVED FROM BfInTA ~ BefundeInTeilauftrag
      =
        TeilauftragProzessquelle -- {1..*} ProzQBefd := BfInTA -> PqBf;
        ProzessquelleTeilauftrag (EXTERNAL) -- {1} SO_AFU_Naturgefahren_20220801.Auftraege.TeilauftragRaumbezug := BfInTA -> TaRb;
    END TeilauftragsObjekte;     

  END AssocProxy;
```

Aktuelles Problem ist, dass die Referenz nicht auf eine Klasse verweist:
Referenced model element "SO_AFU_Naturgefahren_20220801.AssocProxy.ProzQBefd" should be a CLASS or ASSOCIATION.
und der View zum Befund ist nötig, um auf Seite Prozessquelle zwingend mindestens eine zugewiesene Geometrie zu haben

Fazit: Keine Option


## Variante 4: "lazy" Ref-Attribut zu Teilauftragsnummer UND Löschung der Association Prozessquellle-Teilauftrag 

Idee: Explizite Aufhebung einer technischen Verknüpfung und Schaffung eines bezugs über ein unabhängiges, aber bedingtes Verweisattribut.

```
    CLASS TeilauftragRaumbezug (ABSTRACT) =
      Teilauftragsnummer : TEXT*12;
      Bemerkung : TEXT*100;
      /** Auftragnehmer gemaess Autorenliste */
      Auftragnehmer : MANDATORY Autor;
      /** Abklaerungsperimeter = Perimeter, welcher untersucht werden soll */
      Name : MANDATORY TEXT*80;
      Geometrie : MANDATORY Einzelflaeche;
      /** Beurteilung, welcher Teilprozess zu welchem Grad untersucht wurde */
      Beurteilungsstatus: MANDATORY Beurteilung;
    /* Req.28 */
    UNIQUE Geometrie;
    UNIQUE Teilauftragsnummer;
    END TeilauftragRaumbezug;


    /** Beschreibung der Prozessquelle */
    CLASS Prozessquelle =
      /** Name der Prozessquelle (Dorfbach) */
      ProzessquellenName : MANDATORY TEXT*80;
      Hauptprozess : MANDATORY Hauptprozess;
      RefTeilauftrag : MANDATORY TEXT*12;
    EXISTENCE CONSTRAINT RefTeilauftrag REQUIRED IN SO_AFU_Naturgefahren_20220801.Auftraege.TeilauftragRaumbezug:Teilauftragsnummer;  
    END Prozessquelle;
```

Und als Konsequenz: Auskommentieren der Association!

```
    !!ASSOCIATION TeilauftragProzessquelle =
    !!  /** Ein Teilauftrag hat entweder keine oder eine Prozessquelle.
    !!  *   (Ein Teilauftrag hat entweder einen Abklaerungsperimeter, eine Prozessquelle oder beides)
    !!  *   Hat ein Teilauftrag KEINE Prozessquelle, ist durch den Auftragnehmer eine Prozessquelle zu definieren.
    !!    */
    !!  TeilauftragProzessquelle -- {0..1} Prozessquelle;
    !!  ProzessquelleTeilauftrag (EXTERNAL) -- {1} SO_AFU_Naturgefahren_20220801.Auftraege.TeilauftragRaumbezug;
    !!END TeilauftragProzessquelle;
```

Begründung:

* Die Teilaufträge werden ja vom AfU vorgängig erfasst und dem Büro mitgeliefert. 
* Insofern müssen die Büros bei einer Prozessquelle dies zugeordnete Teilauftragsnummer erfassen. 
* Spätestens bei der Validierung wird mit der EXISTENCE CONSTRAINT geprüft, dass diese auch in der Tabelle Auftraege.Auftrag existiert.
* Mit dieser Verknüpfungsart behalten wir die Zuordnung ohne dass stabile OIDs nötig sind oder dass die Auftragsdaten mitimportiert werden müssen.
* Die Association wird gelöscht, um das Prinzip der topic-unabhängigen Datenlieferung zu ermöglichen

Fazit: Diese Modellierung würde den vorgesehenen Datenaustausch unter Berücksichtigung der Rahmenbedingungen ermöglichen.


## Variante 5: stabile Objektidentifikation nur in der Klasse Teilauftrag

Idee: Deklaration einer stabilen Objektidentifikation für die Klasse Teilauftrag und Ausprägung mittels sprechendem Schlüssel

```
      /** Deklaration lokal verwendeter OID */
      TANROID = OID TEXT*36;

    CLASS TeilauftragRaumbezug (ABSTRACT) =
      /** Objektidentifikation mittels sprechendem Schlüssel ("YYYY.<BueroABC>.x.y"), maximale Länge 36 Zeichen **/
      OID AS TANROID;
      ...
```

Fazit: Diese Option scheint gangbar: Die Teilauftraege kriegen im XTF einen sprechenden technischen Schlüssel (TID) welche die Referenzen aus der Klasse Prozessquelle zu beachten haben.