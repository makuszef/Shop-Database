ALTER FUNCTION "DBA"."Ciecie_Budzetu"(  )
RETURNS INT
NOT DETERMINISTIC
BEGIN
    DECLARE Zaoszczedzone INT;
    DECLARE Wskaznik DECIMAL(3, 2);
    DECLARE Ograniczenie INT;
    DECLARE Licznik INT;
    DECLARE Suma INT;

    Set Suma = 0;
    Set Ograniczenie = 0;
    Set Wskaznik = Oblicz_Wskaznik();

    WHILE Wskaznik < 0 and Ograniczenie < 4 LOOP
        Set Ograniczenie = Ograniczenie + 1;

        Select count(Umowa.Id_U) Into Licznik From Umowa 
        Where Rodzaj_Pracy Not Like '%Prezes%'
              and Wynagrodzenie > 1800
              and (Umowa.Data_Zakonczenia_Umowy >= getdate() or Umowa.Data_Zakonczenia_Umowy is NULL)
              and Umowa.Data_Rozpoczecia_Pracy <= getdate();

        Set Suma = Suma + Licznik;

        Update Umowa 
        Set Wynagrodzenie = Wynagrodzenie - 50
        Where Rodzaj_Pracy Not Like '%Prezes%'
              and Wynagrodzenie > 1800
              and (Umowa.Data_Zakonczenia_Umowy >= getdate() or Umowa.Data_Zakonczenia_Umowy is NULL)
              and Umowa.Data_Rozpoczecia_Pracy <= getdate();

        Set Wskaznik = Oblicz_Wskaznik();
    END LOOP;

    Set Zaoszczedzone = 50 * Suma;
	RETURN Zaoszczedzone;
END