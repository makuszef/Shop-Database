ALTER TRIGGER "Sprawdz_Wynagrodzenie" BEFORE INSERT, UPDATE
ORDER 1 ON "DBA"."Umowa"
REFERENCING OLD AS Stara_Umowa NEW AS Nowa_Umowa 
FOR EACH ROW 
BEGIN
    DECLARE WynagrodzenieDyrektora INT;
    DECLARE NoweWynagrodzenie INT;

    Set NoweWynagrodzenie = Nowa_Umowa.Wynagrodzenie;

    Select top 1 Umowa.Wynagrodzenie Into WynagrodzenieDyrektora From Umowa
    Where Umowa.Rodzaj_Pracy Like '%Dyrektor%'
    Order By Umowa.Wynagrodzenie asc;

    IF Nowa_Umowa.Rodzaj_Pracy Not Like '%Dyrektor%' THEN
        While NoweWynagrodzenie > WynagrodzenieDyrektora LOOP
            Set NoweWynagrodzenie=NoweWynagrodzenie-200;
        END LOOP;
    ENDIF;        

    Set Nowa_Umowa.Wynagrodzenie=NoweWynagrodzenie;

END