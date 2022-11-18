# Erfassungsmodell Naturgefahrenkarte Solothurn / Auftragsverwaltung

Diese Dokumentation beschreibt die Auftragsverwaltung in QGIS für die Bereitstellung der Naturgefahren-Karte Erfassungs-Aufträge.

## Ausgangslage

QGIS-Projekt: `so.afu.ngkso.auftragsverwaltung.qgs`

## Arbeitsablauf

### Erfassung Basis-Dataset
Das Basis-Dataset dient dazu, Datensätze ohne Bezug zu Teilaufträgen zuzuweisen.
ModelBaker > Dataset Manager: Neues Dataset erfassen und Baskets für das ausgewählte Dataset erzeugen.

![erf1_baseset](https://user-images.githubusercontent.com/3465512/202737735-2bb105ef-e9d5-4221-a31f-baed27b6d91d.png)


### Erfassung Auftrag
 1. Auftragsdaten erfassen (Basket-Zuweisung: Basis-Dataset)

![erf2_auftrag](https://user-images.githubusercontent.com/3465512/202737773-f4113ece-37c3-4f0c-9792-f3284a7137a3.png)

### Erfassung Teilauftrag und Prozessquelle
 1. Dataset und Baskets für Teil-Auftrag erfassen: zB. `2023.1-BüroABC_Bucheggberg_Wasser`
 2. Teilauftrag erfassen (inkl. Abklärungsperimeter und Zuweisung zu Auftrag)  und dem Basket zuweisen. In der Erfassungsmaske ist die OID (t_ili_tid)

![erf3_teilauftrag](https://user-images.githubusercontent.com/3465512/202737830-546b1928-c260-4303-a5c2-b61f572905b5.png)

 3. Prozessquelle erfassen und Teilauftrag zuweisen

![erf4_prozessquelle](https://user-images.githubusercontent.com/3465512/202737858-5c2a3f26-2ac6-4d5c-9c27-bece787673c6.png)
![erf4_zuweisungteilauftrag](https://user-images.githubusercontent.com/3465512/202737884-f9799beb-01be-4c4d-892e-6172b8e13a80.png)

## Daten-Export
Export der Daten des Datasets 2023.1-BüroABC_Bucheggberg_Wasser:

![erf5_datenexport](https://user-images.githubusercontent.com/3465512/202737923-52a74256-0dfc-4646-9477-6eefdf9ce12e.png)

Stabile Referenz auf Teilauftrag in der XTF-Datei:

     <SO_AFU_Naturgefahren_20220801.Befunde.TeilauftragProzessquelle><TeilauftragProzessquelle  REF="b0b20f08-e876-4c2c-9e5e-87d9c162dabf"></TeilauftragProzessquelle><ProzessquelleTeilauftrag  REF="2023.Geo7.12-1"></ProzessquelleTeilauftrag>

