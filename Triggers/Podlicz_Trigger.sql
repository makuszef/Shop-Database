ALTER TRIGGER "Podlicz" AFTER INSERT, DELETE
ORDER 1 ON "DBA"."Pozycja_Faktury"
REFERENCING OLD AS Stara_Pozycja NEW AS Nowa_Pozycja 
FOR EACH ROW 
BEGIN
    IF DELETING THEN 
        Update Faktura
        Set Kwota_Do_Zaplaty=Kwota_Do_Zaplaty-Stara_Pozycja.Kwota_Brutto
        Where Faktura.Nr_F=Stara_Pozycja.Nr_F;
    ELSEIF INSERTING THEN 
        Update Faktura
        Set Kwota_Do_Zaplaty=Kwota_Do_Zaplaty+Nowa_Pozycja.Kwota_Brutto
        Where Faktura.Nr_F=Nowa_Pozycja.Nr_F;
    END IF;
END