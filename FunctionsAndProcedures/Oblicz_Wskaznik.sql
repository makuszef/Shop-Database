ALTER FUNCTION "DBA"."Oblicz_Wskaznik"(  )
RETURNS DECIMAL(3, 2)
NOT DETERMINISTIC
BEGIN
    DECLARE Wskaznik DECIMAL(3, 2);
	DECLARE ObenceId INT;
    DECLARE ObecnyZarobek INT;
    DECLARE ObecneWynagrodzenie INT;
    DECLARE MaksId INT;

    DECLARE kursor CURSOR FOR
       Select Pracownik.Id_PR,
              CEILING(sum(Faktura.Kwota_Do_Zaplaty)), 
              sum(Umowa.Wynagrodzenie)
       From Faktura 
            inner join Pracownik on Pracownik.Id_PR=Faktura.Id_PR
            inner join Umowa on Umowa.Id_PR=Pracownik.Id_PR
       Where (Umowa.Data_Zakonczenia_Umowy >= getdate() or Umowa.Data_Zakonczenia_Umowy is NULL)
              and Umowa.Data_Rozpoczecia_Pracy <= getdate() 
              and Umowa.Rodzaj_Pracy Like '%Sprzedawca%'
              and datediff(month,Faktura.Data_Wystawienia, getdate()) <= 3
       Group By Pracownik.Id_PR, Umowa.Id_U;
   
   OPEN kursor;
   FETCH NEXT kursor       
         INTO ObenceId, ObecnyZarobek, ObecneWynagrodzenie;
   Set Wskaznik = (ObecnyZarobek-ObecneWynagrodzenie)/ObecnyZarobek;
   //message (ObecnyZarobek-ObecneWynagrodzenie)/ObecnyZarobek to client;
  
   LP:
   LOOP
      FETCH NEXT kursor
         INTO ObenceId, ObecnyZarobek, ObecneWynagrodzenie;
      IF SQLSTATE <> 0 THEN
         LEAVE LP;
      END IF;
      IF Wskaznik < (ObecnyZarobek-ObecneWynagrodzenie)/ObecnyZarobek THEN
         Set Wskaznik = (ObecnyZarobek-ObecneWynagrodzenie)/ObecnyZarobek;
      END IF;
   END LOOP LP; 

   CLOSE kursor;
   RETURN Wskaznik;
END