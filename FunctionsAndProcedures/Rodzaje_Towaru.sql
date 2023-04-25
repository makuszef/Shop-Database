CREATE MATERIALIZED VIEW "DBA"."Rodzaje_Towaru"( )
IN "system" AS
SELECT Nazwa_Rodzaj_Towaru,
       sum(Pozycja_Faktury.Liczba_Towaru_Pozycja_Faktury) LiczbaKupionychProduktow,
       count(DISTINCT Faktura.Id_KL) LiczbaRoznychKlientowKtorzyZakupili
From Rodzaj_Towaru inner join Towar on Towar.Id_RT=Rodzaj_Towaru.Id_RT
                   inner join Pozycja_Faktury on Towar.Id_T=Pozycja_Faktury.Id_T
                         and Towar.Id_RT=Pozycja_Faktury.Id_RT
                   inner join Faktura on Faktura.Nr_F=Pozycja_Faktury.Nr_F
                   inner join Klient on Klient.Id_KL=Faktura.Id_KL
Group By Rodzaj_Towaru.Nazwa_Rodzaj_Towaru, Rodzaj_Towaru.Id_RT
Order By LiczbaKupionychProduktow desc