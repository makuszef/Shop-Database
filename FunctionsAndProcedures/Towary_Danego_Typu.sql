ALTER PROCEDURE "DBA"."Towary_Danego_Typu"(IN NazwaRodzajuTowaru CHAR(40),
                                           IN MinCena INT DEFAULT 0,
                                           IN MaxCena INT DEFAULT NULL,
                                           IN Sortowanie CHAR(1) DEFAULT 'A')

RESULT( NazwaTowaru CHAR(40), 
        Cena_Towaru DECIMAL(34,2) )
BEGIN
    IF MaxCena is NULL THEN
        Select max(Towar.Cena_Netto_Towar) into MaxCena 
        From Towar inner join Rodzaj_Towaru on Towar.Id_RT=Rodzaj_Towaru.Id_RT
        Where Rodzaj_Towaru.Nazwa_Rodzaj_Towaru Like '%'+NazwaRodzajuTowaru+'%';
    ENDIF;
    IF Sortowanie LIKE 'A' THEN
    	Select Towar.Nazwa_Towar,Towar.Cena_Netto_Towar From Towar inner join Rodzaj_Towaru 
                                                             on Towar.Id_RT=Rodzaj_Towaru.Id_RT
        Where Rodzaj_Towaru.Nazwa_Rodzaj_Towaru Like '%'+NazwaRodzajuTowaru+'%'
              and Towar.Cena_Netto_Towar >= MinCena 
              and Towar.Cena_Netto_Towar <= MaxCena
        Order By Towar.Cena_Netto_Towar ASC
    ELSE 
        Select Towar.Nazwa_Towar,Towar.Cena_Netto_Towar From Towar inner join Rodzaj_Towaru 
                                                             on Towar.Id_RT=Rodzaj_Towaru.Id_RT
        Where Rodzaj_Towaru.Nazwa_Rodzaj_Towaru Like '%'+NazwaRodzajuTowaru+'%'
              and Towar.Cena_Netto_Towar >= MinCena 
              and Towar.Cena_Netto_Towar <= MaxCena
        Order By Towar.Cena_Netto_Towar DESC
    ENDIF;
END