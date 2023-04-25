ALTER PROCEDURE "DBA"."Daj_Premie"( IN WielkoscDodatku INT )

BEGIN
    DECLARE Id_Pracownika INT;
    DECLARE Id_Typu_Umowy INT;
    DECLARE Id_Umowy INT;
    DECLARE LiczbaDodatkow INT;
    DECLARE kursor CURSOR FOR
       Select Pracownik.Id_PR,
              Umowa.Id_U,
              count(Dodatek.Id_D) LiczbaDodatkow
       From Faktura 
            inner join Pracownik on Pracownik.Id_PR=Faktura.Id_PR
            inner join Umowa on Umowa.Id_PR=Pracownik.Id_PR
            inner join Dodatek on Dodatek.Id_U=Umowa.Id_U
       Where (Umowa.Data_Zakonczenia_Umowy >= getdate() or Umowa.Data_Zakonczenia_Umowy is NULL)
              and Umowa.Data_Rozpoczecia_Pracy <= getdate()
       Group By Pracownik.Id_PR, Umowa.Id_U;

   OPEN kursor;
   LP:
   LOOP
      FETCH NEXT kursor
         INTO Id_Pracownika, Id_Umowy, LiczbaDodatkow;
      IF SQLSTATE <> 0 THEN
         LEAVE LP;
      END IF;
      IF LiczbaDodatkow=0 THEN
         Select Typ_Umowy.Id_TU into Id_Typu_Umowy 
         From Typ_Umowy inner join Umowa on Typ_Umowy.Id_TU=Umowa.Id_U
         Where Umowa.Id_U=Id_Umowy;

         Insert Dodatek(Id_D, Id_TU, Id_U, Wielkosc_Dodatek, Data_Przyznania)
         Values (Dla_Id_D.nextval, Id_Typu_Umowy, Id_Umowy, WielkoscDodatku, getdate())
      END IF;
   END LOOP LP; 
END