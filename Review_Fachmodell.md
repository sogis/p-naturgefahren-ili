# p-naturgefahren-ili: Review des Fachmodells

## Formale Aspekte ili Modellbeschreibung

### Aufbau der ILI-Datei

* Codierung 'UTF-8 ohne BOM' führt zu Lesefehler bei ilitools: korrigieren
* tendenziell etwas überkommentiert. Auf Kommentare, welche die ILI Syntax repetieren, entfernen.
* Header, Revision-History AGI Solothurn fehlt
* Issuer auf geo.so.ch/models/AFU setzen
* VERSION aktualisieren

### Betitelung der Objekte

* Topic Auftrag: besser Plural
* Enum Teilprozesse: besser Singular
* Enum: Intensitaeten: besser Singular
* Association: Regel mit Präfix 'assoc' ungewöhnlich: besser 'r'
* Klasse Fliessrichtungspfeile: besser Singular
* Klasse Untergeschosse: besser Singular

## Syntaktische Aspekte ili Modellbeschreibung

* IMPORTS von INTERLIS muss nicht explizit aufgeführt werden.
* IMPORTS Basismodelle auf UNQUALIFIED  gesetzt
* Feststellung: Das Modell enthält keine Elemente, welche per se von ili2gpkg oder Geopackage aktuell nicht unterstützt werden. (Klassen mit mehreren Geometriefeldern)
* Optimierung: Verwendung von Einheiten im Eigenschaftsnamen (zB. "ProzessquelleSteinBlockschlag.Volumen_m3") wird besser mittels konkreter Typisierung gelöst. !!TODO (Abhängigkeit zu MGDM)
* UNIQUE Constraint auf Prozessquelle (sinnvoll aufgrund der Erfassungsmethodik über Prozessquelle)
* die beiden Structures sind sinnvoll gewählt
* Kartographische_Produkte.Untergeschosse.EGID Nummernbereich angepasst (gemäss DM.flex). Alter Nummernbereich führte zu Fehler in GPKG (Eigenschaft kann nicht erfasst werden)

### Fragen

Zusammenhang zu MGDM???:

* Auftrag.AuftragsID: MANDATORY INTERLIS.UUIDOID; ist das gewollt? bzw. entspricht dies der ID?
* Prozessquelle.PQID: MANDATORY INTERLIS.UUIDOID; ist das gewollt? bzw. entspricht dies der ID? Vergabe durch Kanton (analog Auftrag)?
* Abklaerungsperimeter.APID: MANDATORY INTERLIS.UUIDOID; ist das gewollt? bzw. entspricht dies der ID? Vergabe durch Kanton (analog Auftrag)?
* TeilauftragRaumbezug.TAID: MANDATORY INTERLIS.UUIDOID; ist das gewollt? bzw. entspricht dies der ID? Vergabe durch Kanton (analog Auftrag)?

## ili2gpkg Parametrisierung

ili2gpkg-4.6.1.jar --schemaimport --dbfile NGKSO2021-202206080900.gpkg --createEnumTabs --createNumChecks --createFk --createFkIdx --createGeomIdx --createMetaInfo --createTypeConstraint --createEnumTabsWithId (?) --createTidCol --smart2Inheritance --strokeArcs --defaultSrsCode 2056 --models NGKSO2021 NGK_SO_V23d_edited.ili

## Erfassungsprozesse

### Erfassungsreihenfolge

1. Abklärungsperimeter
2. Auftrag - Bericht
3. Teilauftrag und Zuordnung zu Auftrag, Abklärungsperimeter und Autor (1 Maske)
4. Prozessquelle (optional, kann ich auch in Schritt 5 passieren)
5. ProzessquelleSteinBlockschlagPunkt und Zuordnung zu Prozessquelle (1 Maske)
6. Fliessrichtung und Zuordnung zu Prozessquelle (1 Maske)
7. Befund und Zuordnung zu Prozessquelle (1 Maske)

* Befunde sind auf 13 Klassen verteilt. Dieser Umstand bedingt, dass die Klassierung stets vor der Erfassung der Geometrie passiert (dies entspricht u.E. aber auch der Denk- und Arbeitsweise)
* Dadurch, dass die Befunde auf verschiedene Klassen verteilt sind, ist die Zuordnung aller Befunde zu einer Prozessquelle umständlich (bzw. verteilt)

#### alternative Erfassungsmethode

1. Vorbereitung: Erfassung Auftrag - Bericht / Erfassung Abklerungsperimeter / Erfassung Autor
2. Setin- / Blockschlag Prozesse: Einstieg auf ProzessquellePolygon bzw. -Punkt ()
3. alle anderen Prozesse: Einstieg auf Prozessquelle
4. Erfassung Teilauftrag XY und Zuweisung Autor
5. Zuordnung Perimeter
6. Zuordnung Auftrag (Bericht)
7. Erfassung Befund
8. Erfassung Fliessrichtungspfeile

fertig

### Erfassungshinweise

* Drehwinkel (zB. Richtungspfeile): Aktuell über Eingabe des Azimut-Wertes, Symbolisierung variabel -> Kontrolle

### Verschiedene Hinweise

* TeilAuftragRutschSturz kriegt von ModelBaker auch Beziehungselemente zu den anderen TeilAuftrags-Klassen. Falsch!!