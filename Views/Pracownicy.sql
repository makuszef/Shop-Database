ALTER VIEW "DBA"."Pracownicy"( )
AS
Select Pracownik.Id_PR, 
       Pracownik.Nazwisko,
       Pracownik.Imie,
       sum(Faktura.Kwota_Do_Zaplaty) SprzedazFaktur,
       count(Faktura.Nr_F) WystawioneFaktury
From Faktura 
    inner join Pracownik on Pracownik.Id_PR=Faktura.Id_PR
    inner join Umowa on Umowa.Id_PR=Pracownik.Id_PR
Where datediff(month,Faktura.Data_Wystawienia, getdate()) <= 3
      and (Umowa.Data_Zakonczenia_Umowy >= getdate() or Umowa.Data_Zakonczenia_Umowy is NULL)
      and Umowa.Data_Rozpoczecia_Pracy <= getdate() 
Group By Pracownik.Id_PR, Pracownik.Nazwisko, Pracownik.Imie
Order By SprzedazFaktur desc