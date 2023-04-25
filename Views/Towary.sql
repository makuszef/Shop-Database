ALTER VIEW "DBA"."Towary"(  )
AS
Select Towar.Nazwa_Towar, 
       sum(Pozycja_Faktury.Liczba_Towaru_Pozycja_Faktury) LiczbaKupionychProduktow,
       sum(Pozycja_Faktury.Kwota_Netto) Zarobek
From Towar inner join Pozycja_Faktury on Towar.Id_T=Pozycja_Faktury.Id_T
                      and Towar.Id_RT=Pozycja_Faktury.Id_RT
           inner join Faktura on Faktura.Nr_F=Pozycja_Faktury.Nr_F
Where datediff(day,Faktura.Data_Wystawienia, getdate()) <= 90
Group By Towar.Id_T, Towar.Nazwa_Towar, Towar.Id_RT
Order By LiczbaKupionychProduktow desc