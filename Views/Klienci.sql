ALTER VIEW "DBA"."Klienci"(  )
AS
Select Klient.Id_KL,
       Klient.Imie, 
       Klient.Nazwisko,
       sum(Faktura.Kwota_Do_Zaplaty) as WydanePieniadze,
       sum(Pozycja_Faktury.Liczba_Towaru_Pozycja_Faktury) as LiczbaZakupionychTowarow
From Klient inner join Faktura on Faktura.Id_KL=Klient.Id_KL
            inner join Pozycja_Faktury on Pozycja_Faktury.Nr_F=Faktura.Nr_F
Where datediff(month, Faktura.Data_Wystawienia, getdate()) < 6
Group By Klient.Id_KL, Klient.Imie, Klient.Nazwisko
Order By WydanePieniadze desc, LiczbaZakupionychTowarow asc