# Custom Functions

Diese Auflistung beschreibt die benutzerspezifischen Funktionen welche im Datenmodell NGKSO für die Komplettierung der QS-Regeln zusätzlich zu entwickeln sind.

* Die Funktionen sind in einem Funktionsmodell _NGK_FunctionsExt_ deklariert.
* Sowohl die Funktionsnamen wie auch die Parameter sind als Vorschlag zu verstehen. Die Definition sollte im Rahmen einer Spezifikation erfolgen.
* Die Spezifikation wie auch die Implementierung der Funktionen selbst besteht noch nicht.

Das Funktionsmodell _NGK_FunctionsExt_ enthält eine grobe Beschreibung der Funktion inklusive der Parameter.

| Klasse(n)           | Req#   | Constraint                                                                                                               |
|---------------------|--------|--------------------------------------------------------------------------------------------------------------------------|
|TeilauftragRaumbezug | 3      | MANDATORY CONSTRAINT NGK_FunctionsExt.GetArea(THIS, "Geometrie") > 100;                                                  |
|TeilauftragRaumbezug | 4      | MANDATORY CONSTRAINT NGK_FunctionsExt.IsInside(THIS, "Geometrie", "HHGebiete_Kantonal", "SO");                           |
|TeilauftragRaumbezug | 5      | MANDATORY CONSTRAINT NGK_FunctionsExt.GetHolesCount(THIS, "Geometrie") == 0                                              |
|Befund               | 21     | MANDATORY CONSTRAINT NGK_FunctionsExt.GetHolesCount(THIS, "Geometrie") == 0;                                             |
|Befund               | 9,14   | MANDATORY CONSTRAINT NGK_FunctionsExt.IsContainedBy(THIS, "Geometrie", >Befund>BefundProzessquelle>TeilauftragRaumbezug);|
|Befund               | 11     | MANDATORY CONSTRAINT NGK_FunctionsExt.GetArea(THIS, "Geometrie") > 5;                                                    |
|Befundxxxx           | 10     | SET CONSTRAINT NGK_FunctionsExt.CheckBefundIntegrity(ALL, "BefundProzessquelle", "IWCode");                              |
|Kennwertxxxx         | 18     | MANDATORY CONSTRAINT NGK_FunctionsExt.GetArea(THIS, "Geometrie") > 5;                                                    |
|Kennwertxxxx         | 15     | SET CONSTRAINT NGK_FunctionsExt.CheckBefundIntegrity(ALL, "BefundProzessquelle", "h");                                   |
|Untergeschosse       | 23     | MANDATORY CONSTRAINT NGK_FunctionsExt.CheckBefundIntegrity(THIS, "ProzessquelleBefund", "Geometrie");                    |
