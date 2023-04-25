ALTER TRIGGER "Sprytna_Znizka" AFTER INSERT
ORDER 1 ON "DBA"."Znizka"
REFERENCING NEW AS Nowe_Znizki
FOR EACH STATEMENT 
BEGIN
    DECLARE Id_Znizki INT;
    DECLARE DataAktywacji DATE;
    DECLARE kursor CURSOR FOR 
    Select Id_Z, Data_Aktywacji
    From Nowe_Znizki;
    Lp:
    LOOP
        FETCH NEXT kursor INTO Id_Znizki, DataAktywacji;
        IF SQLSTATE <> 0 THEN
            LEAVE Lp
        END IF;
        IF DataAktywacji <= getdate() THEN
            Update Towar
            Set Towar.Cena_Netto=Towar.Cena_Netto*1.01
            Where Towar.Id_T=Znizka_Towar.Id_T and IdZniki=Znizka_Towar.Id_Z;
        END IF;
    END LOOP Lp;
    CLOSE kursor;
END