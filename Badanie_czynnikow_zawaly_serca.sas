
/*      Analiza czynnikow wplywajacych na wystepowanie zawalu serca przy uzyciu regresji logistycznej       */


/* ustalenie katalogu roboczego */

x 'cd C:\Users\123\Desktop\EAD';
libname dane 'C:\Users\123\Desktop\EAD\dane';
proc import datafile='zawaly.csv' out=pacjenci dbms=csv replace;
run;


proc logistic data= pacjenci;
model target(event='1') = mezczyzna tetno bol_typ3 bol_typ1 spadek_ST
ST_nach2 szer_zyly thal1 /rsquare;
output out = pred_logit p=p;
run;
data pred_logit;
set pred_logit;
if p<=0.5
then y=0;
if p>0.5
then y=1;
run;
proc freq data=pred_logit;
tables target*y / out=cross_results;
run;
data cross_results;
set cross_results;
if target = 1 and y = 1 then result_type = 'TP';
if target = 1 and y = 0 then result_type = 'FN';
if target = 0 and y = 1 then result_type = 'FP';
if target = 0 and y = 0 then result_type = 'TN';
run;
data pred_logit;
set pred_logit;
if target=y then dobra_klasyfikacja=1;

else dobra_klasyfikacja=0;

run;
proc freq data=pred_logit;
tables dobra_klasyfikacja;


run;
proc univariate data=Pacjenci;
var wiek;
histogram wiek/weibull;
run;

/* W N I O S K I */

/* W badaniu zastosowano model Logit do predykcji prawdopodobieñstwa zawa³u serca
u pacjentów, u których taki stan by³ podejrzewany przez lekarzy ze szpitala w Cleveland.
Wyszczególniono 7 czynników. Na podstawie informacji z tabeli klasyfikacyjnej dla punktu odciêcia
p =0.5 Count R2 dla modelu wyniós³ 84.49%, i z tak¹ dok³adnoœci¹ pozwala okreœliæ kto przejdzie zawa³
serca a kto nie. Lepiej oszacowana zosta³a specyficznoœæ, która wynios³a 86.4%, niewiele gorzej
wra¿liwoœæ, 83.15%. Zbiór danych nie pozwoli³ na prawdziwe oszacowanie wp³ywu dwóch czêsto
szacowanych zmiennych w tego typu badaniach: wieku badanych, gdy¿ 95% badanych by³o w grupie
ryzyka przejœcia zawa³u oraz p³ci, gdy¿ ze wzglêdu na specyfikê doboru próby wyniki mimo istotnoœci
statystycznej by³y sprzeczne z wiedz¹ naukow¹. Przez odrzucenie zmiennej zwi¹zanej z p³ci¹ model sta³
siê bardziej ogólny, trac¹c przy tym 1.3% miary adjusted R2. Z badania wynika, ¿e bóle w klatce
piersiowej, niezwi¹zane z dusznic¹ maj¹ wiêkszy wp³yw na szansê przejœcia zawa³u serca ni¿ bóle
zwi¹zane z dusznic¹, jednak wzglêdem poziomu bazowego jest to kolejno ponad 5-krotnie i 4-krotnie
wiêksza szansa. Wniosek ten potwierdza hipotezê badawcz¹ o bólu w klatce piersiowej jako jednym
z kluczowych czynników pozwalaj¹cych stwierdziæ zawa³ miêœnia sercowego. Talasemia z widocznymi
objawami niedoboru krwi w miêœniu sercowym tak¿e jest istotnym czynnikiem, zwiêksza szansê
na zawa³ ponad 6-krotnie wzglêdem osób zdrowych. Nachylenie odcinka ST w górê w badaniu EKG
w stanie w spoczynku zwiêksza szansê na zawa³ dwukrotnie. Istotne okaza³y siê tak¿e wyniki
Fluoroskopii, ka¿da widoczna w badaniu ¿y³a zmniejsza szansê na zawa³ do 42.5%. Spadek nachylenia
odcinka ST w badaniu wysi³kowym wzglêdem badania w stanie spoczynku zmniejsza szansê o ponad
po³owê. Istotnym ograniczeniem w stwierdzeniu wp³ywu p³ci i wieku w badaniu by³a wielkoœæ bazy
danych i dobór próby, dlatego dalsze badania powinny opieraæ siê na wiêkszych zbiorach danych, gdzie
nie wystêpuje problem selekcji próby. Badanie mo¿na rozwin¹æ tak¿e poprzez zwiêkszenie zestawu
zmiennych niezale¿nych, które mog¹ mieæ wp³yw na choroby serca, np. Cechy fizyczne pacjentów
jak wzrost, wskaŸnik BMI oraz historia leczenia. /*
