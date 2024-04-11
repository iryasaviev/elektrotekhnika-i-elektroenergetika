Kс=[0.4 0.3 0.45 0.3 0.45 0.4 0.4 0.45 0.45 0.55 0.45 0.8 0.8 0.8]
Pуст=[100.86 78.45 61.2 89 62 101.26 47.6 16 96 215 65.7 147.68 12.23 13.5]
Pустосв=[06.38 12.35 13 7.4 12.5 15.6 10 2.5 8.2 14.7 8.95 4.2 0.95 0]
Cosφ=[0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.98 0.95 0.75 0.65 0.65]

nums=[]
Pр=[]
PрSum=0
Qр=[]
QрSum=0
Pро=[]
PроSum=0
Sр=[]
SрSum=0
Sрио=[]
SриоSum=0
Tgφ=[]

prog_x=1;
while (prog_x<=length(Kс)) 
    Pр(prog_x)=Kс(prog_x)*Pуст(prog_x);
    PрSum=PрSum+Pр(prog_x)

    Tgφ(prog_x)=sqrt(1-Cosφ(prog_x)^2)/Cosφ(prog_x)

    Qр(prog_x)=Pр(prog_x)*Tgφ(prog_x)
    QрSum=QрSum+Qр(prog_x)

    Pро(prog_x)=Kс(prog_x)*Pустосв(prog_x)
    PроSum=PроSum+Pро(prog_x)

    Sр(prog_x)=sqrt(Pр(prog_x)^2+Qр(prog_x)^2)
    SрSum=SрSum+Sр(prog_x)

    Sрио(prog_x)=sqrt((Pр(prog_x)+Pро(prog_x))^2+Qр(prog_x)^2)
    SриоSum=SриоSum+Sрио(prog_x)

    nums(prog_x) = prog_x;
    prog_x=prog_x+1;
end;

//format("v", 10)

disp(["№" "tgφ" "Pр" "Qр" "Pро" "Sр" "Sрио"],[nums Tgφ Pр Qр Pро Sр Sрио])
disp([00 00 PрSum QрSum PроSum SрSum SриоSum])

S=sqrt((PрSum+PроSum)^2+QрSum^2)
S_formula=strcat(["√(" string(PрSum) "+" string(PроSum) ")^2+" string(QрSum) "^2=" string(S)])
disp("Первоначальные потери на стороне 10/0,4 кВА:",S_formula)

Pm=0.02*S
Pm_formula=strcat([string(0.02) "*" string(S) "=" string(Pm)])
disp("Активные потери в трансформаторах (кВт):", Pm_formula)

Qm=0.1*S
Qm_formula=strcat([string(0.1) "*" string(S) "=" string(Qm)])
disp("Активные потери (кВАр):",Qm_formula)

// 0.95!!! - понять откуда берётся (коэффициент, который учитывает несовпаление пиков компонентов нагрузки)
kрм=0.95

PрSum1=PрSum*kрм+PроSum+Pm
PрSum1_formula=strcat([string(PрSum) "*" string(kрм) "+" string(PроSum) "+" string(Pm) "=" string(PрSum1)])
disp("Активная мощность на шинах ГПП (кВт):",PрSum1_formula)

QрSum1=QрSum*kрм+PроSum+Qm
QрSum1_formula=strcat([string(QрSum) "*" string(kрм) "+" string(PроSum) "+" string(Qm) "=" string(QрSum1)])
disp("Расчетная реактивная мощность (кВАр):",QрSum1_formula)

Qm1=kрм+QрSum1
Qm1_formula=strcat([string(kрм) "+" string(QрSum1) "=" string(Qm1)])
disp("Максимальная реактивная мощность (кВАр):",Qm1_formula)

// 0.33!!! - понять откуда берётся (оптимальное значение тангенса)
tg𝛾h=0.33

Qэ=tg𝛾h*PрSum1
Qэ_formula=strcat([string(tg𝛾h) "*" string(PрSum1) "=" string(Qэ)])
disp("Заданная мощность от энергосистемы (кВАр):",Qэ_formula)

Qку=Qm1-Qэ
Qку_formula=strcat([string(Qку) "-" string(Qэ) "=" string(Qку)])
disp("Расчетная мощность которая может быть скомпнсирована ККУ (кВАр):",Qку_formula)




