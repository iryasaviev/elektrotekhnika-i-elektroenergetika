//## 2.1 Расчёт нагрузок
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

    // $\sqrt(1-Cosφ(prog_x)^2)/Cosφ(prog_x)$
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

format("v", 7)

disp(["№" "tgφ" "Pр" "Qр" "Pро" "Sр" "Sрио"],[nums Tgφ Pр Qр Pро Sр Sрио])
disp([00 00 PрSum QрSum PроSum SрSum SриоSum])

// $S=\sqrt((PрSum+PроSum)^2+QрSum^2)$
S=sqrt((PрSum+PроSum)^2+QрSum^2)
S_formula=strcat(["√(" string(PрSum) "+" string(PроSum) ")^2+" string(QрSum) "^2=" string(S)])
disp("Первоначальные потери на стороне 6/0,4 кВА:",S_formula)

// $Pm=0.02*S$
Pm=0.02*S
Pm_formula=strcat([string(0.02) "*" string(S) "=" string(Pm)])
disp("Активные потери в трансформаторах (кВт):", Pm_formula)

// $Qm=0.1*S$
Qm=0.1*S
Qm_formula=strcat([string(0.1) "*" string(S) "=" string(Qm)])
disp("Активные потери (кВАр):",Qm_formula)

// 0.95!!! - понять откуда берётся (коэффициент, который учитывает несовпаление пиков компонентов нагрузки)
kрм=0.95

// $PрSum1=PрSum*kрм+PроSum+Pm$
PрSum1=PрSum*kрм+PроSum+Pm
PрSum1_formula=strcat([string(PрSum) "*" string(kрм) "+" string(PроSum) "+" string(Pm) "=" string(PрSum1)])
disp("Активная мощность на шинах ГПП (кВт):",PрSum1_formula)

// $QрSum1=QрSum*kрм+PроSum+Qm$
QрSum1=QрSum*kрм+PроSum+Qm
QрSum1_formula=strcat([string(QрSum) "*" string(kрм) "+" string(PроSum) "+" string(Qm) "=" string(QрSum1)])
disp("Расчетная реактивная мощность (кВАр):",QрSum1_formula)

// $kрм+QрSum1$
Qm1=kрм+QрSum1
Qm1_formula=strcat([string(kрм) "+" string(QрSum1) "=" string(Qm1)])
disp("Максимальная реактивная мощность (кВАр):",Qm1_formula)

// 0.33!!! - понять откуда берётся (оптимальное значение тангенса)
tg𝛾h=0.33
TG_FIH=0.54

// $Qэ=tg𝛾h*PрSum1$
Qэ=tg𝛾h*PрSum1
Qэ_formula=strcat([string(tg𝛾h) "*" string(PрSum1) "=" string(Qэ)])
disp("Заданная мощность от энергосистемы (кВАр):",Qэ_formula)

// $Qку=Qm1-Qэ$
Qку=Qm1-Qэ
Qку_formula=strcat([string(Qm1) "-" string(Qэ) "=" string(Qку)])
disp("Расчетная мощность которая может быть скомпнсирована ККУ (кВАр):",Qку_formula)

// Требуемая мощность компенсирующего устройства выбирается с учётом наибольшей реактивной мощности Qэ,
// которая может быть передана из сетей энергосистемы. Должно соблюдаться условие:
// Qp-Qk≤Qэ
// где Qр – расчётная потребляемая предприятием реактивная мощность,
// Qk – реактивная мощность, которая должна быть скомпенсирована на предприятии

// УКРЛ56-6,3-225-75 УЗ

Qp1=QрSum1-Qку
Qp1_formula=strcat([string(QрSum1) "-" string(Qку) "=" string(Qp1)])
disp("Некомпенсированная реактивная часть предприятия которая останется после установки КУ:",Qp1_formula)

// $Sp1=\sqrt(PрSum1^2+Qp1^2)$
Sp1=sqrt(PрSum1^2+Qp1^2)
Sp1_formula=strcat(["√" string(PрSum1) "^2" "+" string(Qp1) "^2=" string(Sp1)])
disp("Новое значение мощности:",Sp1_formula)

disp("Мощностные потери в трансформаторах")
∆Pp1=0.02*Sp1
∆Pp1_formula=strcat(["∆Pp1=" "0.02" "*" string(Sp1) "=" string(∆Pp1)])
disp(∆Pp1_formula)

∆Qp1=0.1*Sp1
∆Qp1_formula=strcat(["∆Qp1=" "0.1" "*" string(Sp1) "=" string(∆Qp1)])
disp(∆Qp1_formula)

Sp2=sqrt((PрSum1+∆Pp1)^2+(Qp1+∆Qp1)^2)
Sp2_formula=strcat(["√" "(" string(PрSum1) "+" string(∆Pp1) ")" "^2" "+" "(" string(Qp1) "+" string(∆Qp1) ")" "^2" "=" string(Sp2)])
disp("Полная итоговая мощность на стороне 35кВ (кВА):",Sp2_formula)

// ---------------------------------------------------
//## 2.2. Проверка трансформаторов ГПП на перегрузку и кабельных линий 35кВ (ТМ-630/35/6)
// ---------------------------------------------------
//disp("2.2 ---------------------------------------------------")

//S_TRANSFORMER=630
//U_TRANSFORMER=35

// $Kз.норм=Sp/(2*Sт)$
//Kз.норм=Sp2/(2*S_TRANSFORMER)
//Kз.норм_formula=strcat([string(Sp2) "/" "(" string(2) "*" string(S_TRANSFORMER) ")" "=" string(Kз.норм)])
//disp("Загрузка трансформатора в нормальном режиме работы:",Kз.норм_formula)

// $Kавар=Sp/Sт$
//Kавар=Sp2/S_TRANSFORMER
//Kавар_formula=strcat([string(Sp2) "/" string(S_TRANSFORMER) "=" string(Kавар)])
//disp("Загрузка трансформатора в аварийном режиме работы:",Kавар_formula)

//Imax=Sp2/(sqrt(3)*U_TRANSFORMER)
//Imax_formula=strcat([string(Sp2) "/" "(" "√" string(3) "*" string(U_TRANSFORMER) ")" "=" string(Imax)])
//disp("Максимальный ток линии Imax:",Imax_formula)

//Ipн=Sp2/(2*sqrt(3)*U_TRANSFORMER)
//Ipн_formula=strcat([string(Sp2) "/" "(" string(2) "*" "√" string(3) "*" string(U_TRANSFORMER) ")" "=" string(Ipн)])
//disp("Ipн:",Ipн_formula)

//Iавар=1.4*Sp2/(sqrt(3)*U_TRANSFORMER)
//Iавар_formula=strcat([string(1.4) "*" string(Sp2) "/" "(" "√" string(3) "*" string(U_TRANSFORMER) ")" "=" string(Iавар)])
//disp("Iавар:",Iавар_formula)

// Предельная экономическая плотнсть тока А/мм^2
// 3.1 - кабель с резиновым и пластмассовой изоляцией с медными жилами (4500ч)
// 1.7 -  кабель с резиновым и пластмассовой изоляцией с алюминевыми жилами
//J_ЭК=1.7
J_ЭК1=3.1

//АПвВ 1х50-35

//Sэк=Iавар/J_ЭК
//Sэк_formula=strcat([string(Iавар) "/" string(J_ЭК) "=" string(Sэк)])
//disp("Экономическое сечение:",Sэк_formula)

// ---------------------------------------------------
//## 2.2 Выбор числа, мощности и типа внутренних ТП 
// ---------------------------------------------------
disp("2.2 ---------------------------------------------------")

// Объединение потребителей. Строго индивидуально!
// В моём случае мощности небольшие, поэтому мелкие потребители разделены объединены в конечные 2 потребителя для ТП
disp("Расчет объединенных потребителей")

Ppsum1=sum(Pр)
Qpsum1=sum(Qр)

power_num=1
Ppower_nums_formula_els=[]
Qpower_nums_formula_els=[]
while(power_num<=length(Pр))
    if power_num==1 then
        Ppower_nums_formula_els(power_num)=strcat(["Pp=" string(Pр(power_num))])
        Qpower_nums_formula_els(power_num)=strcat(["Qp=" string(Qр(power_num))])
    else
        Ppower_nums_formula_els(power_num)=strcat(["+" string(Pр(power_num))])
        Qpower_nums_formula_els(power_num)=strcat(["+" string(Qр(power_num))])
    end;
    power_num=power_num+1
end;
Ppower_nums_formula=strcat([strcat(Ppower_nums_formula_els) "=" string(Ppsum1)])
Qpower_nums_formula=strcat([strcat(Qpower_nums_formula_els) "=" string(Qpsum1)])
disp(Ppower_nums_formula,Qpower_nums_formula)

Spsum1=sqrt(Ppsum1^2+Qpsum1^2)
Spsum1_formula=strcat(["Sp1=" "√" string(Ppsum1) "^2" "+" string(Qpsum1) "^2" "=" string(Spsum1)])
disp(Spsum1_formula)

disp("Мощность требуемых компенсирующих устройств (кВАр)")
tgfi=Qpsum1\Ppsum1
tgfi_formula=strcat(["tgfi" "=" string(Qpsum1) "\" string(Ppsum1) "=" string(tgfi)])
disp(tgfi_formula)

Q1ку=Ppsum1*(tgfi-TG_FIH)
Q1ку_formula=strcat(["Q1ку=" string(Ppsum1) "*" "(" string(tgfi) "-" string(TG_FIH) ")" "=" string(Q1ку)])
disp(Q1ку_formula)

// УКМ58 (КРМ)-0,4-25-5 У3
// УКМ58 (КРМ)-0,4-50-25 У3
W_COMPENSATORY=50 // мощность конденсаторной установки
W_COMPENSATORY_COUNT=2 // количество устанавливаемых КУ

Q=Qpsum1-W_COMPENSATORY_COUNT*W_COMPENSATORY
Q_formula=strcat(["Q=" string(Qpsum1) "-" string(W_COMPENSATORY_COUNT*W_COMPENSATORY) "=" string(Q)])
disp("Мощность после установки КУ (кВАр):",Q_formula)

Sp3=sqrt(Ppsum1^2+Q^2)
Sp3_formula=strcat(["S`p1=" "√" string(Ppsum1) "^2" "+" string(Q) "^2" "=" string(Sp3)])
disp("Полная мощность ТП-1",Sp3_formula)

// ТМГ-400/10/0,4
S1_TRANSFORMER=400
U1_TRANSFORMER=10
TRANSFORMER_COUNT=2

// $Kз.норм=Sp/(2*Sт)$
Knormal=Sp3/(TRANSFORMER_COUNT*S1_TRANSFORMER)
Knormal_formula=strcat([string(Sp3) "/" "(" string(TRANSFORMER_COUNT) "*" string(S1_TRANSFORMER) ")" "=" string(Knormal)])
disp("Загрузка ТП-1 в нормальном режиме работы:",Knormal_formula)

// $Kавар=Sp/Sном*(n-1)$
Kcrash=Sp3/(S1_TRANSFORMER*(TRANSFORMER_COUNT-1))
Kcrash_formula=strcat([string(Sp3) "/" "(" string(S1_TRANSFORMER) "*" "(" string(TRANSFORMER_COUNT) "-1" "))" "=" string(Kcrash)])
disp("Загрузка ТП-1 в аварийном режиме работы:",Kcrash_formula)

// ---------------------------------------------------
//## 2.3 Расчет и выбор линий электроснабжения 10кВ
// ---------------------------------------------------
disp("2.3 ---------------------------------------------------")

//TRANSFORMERS_CONSTS=[[S1_TRANSFORMER;U1_TRANSFORMER;TRANSFORMER_COUNT] [S2_TRANSFORMER;U2_TRANSFORMER;TRANSFORMER_COUNT1]]
TRANSFORMERS_CONSTS=[[S1_TRANSFORMER;U1_TRANSFORMER;TRANSFORMER_COUNT]]
//disp(TRANSFORMERS_CONSTS,length(TRANSFORMERS_CONSTS))

disp("Рабочие и аварийные токи ТП:")
transformers_data_num=0
transformer_data_num=1
transfromer_num=1

// ПвП 3х50/16
cabels_data_num=0
cabel_data_num=1
CABLES=[[1;0.9;1.25;206]]
while(transfromer_num<=1)
    current_transformers_s=0
    current_transformers_u=0
    current_transformers_count=0

    while(transformers_data_num<=length(TRANSFORMERS_CONSTS))
        transformers_data_num=transformers_data_num+1
        if transformer_data_num==1 then
            current_transformers_s=TRANSFORMERS_CONSTS(transformers_data_num)
        elseif transformer_data_num==2 then
            current_transformers_u=TRANSFORMERS_CONSTS(transformers_data_num)
        elseif transformer_data_num==3 then
            current_transformers_count=TRANSFORMERS_CONSTS(transformers_data_num)
            transformer_data_num=1
            break
        end;
        transformer_data_num=transformer_data_num+1
     end;

    disp(strcat(["ТП-" string(transfromer_num)]))
    Itn1=((current_transformers_count*current_transformers_s)*(current_transformers_count-1))/(2*sqrt(3)*current_transformers_u)
    Itn1_formula=strcat(["Iн=" string(((current_transformers_count*current_transformers_s)*(current_transformers_count-1))) "/" "(" string(2) "*" "√" string(3) "*" string(current_transformers_u) ")" "=" string(Itn1)])
    disp(Itn1_formula)

    Itcrash1=((current_transformers_count*current_transformers_s)*(current_transformers_count-1))/(sqrt(3)*current_transformers_u)
    Itcrash1_formula=strcat(["Iавар=" string(((current_transformers_count*current_transformers_s)*(current_transformers_count-1))) "/" "(" "√" string(3) "*" string(current_transformers_u) ")" "=" string(Itcrash1)])
    disp(string(Itcrash1_formula))

    Itcrashmax=(J_ЭК1*((current_transformers_count*current_transformers_s)*(current_transformers_count-1)))/(sqrt(3)*current_transformers_u)
    Itcrashmax_formula=strcat(["Iавар.макс=" string(J_ЭК1) "*" string(((current_transformers_count*current_transformers_s)*(current_transformers_count-1))) "/" "(" "√" string(3) "*" string(current_transformers_u) ")" "=" string(Itcrashmax)])
    disp(string(Itcrashmax_formula))

    // Экономическое сечение кабеля
    Seconom=Itcrashmax/J_ЭК1
    Seconom_formula=strcat(["Sэк=" string(Itcrashmax) "/" string(J_ЭК1) "=" string(Seconom)])
    disp(string(Seconom_formula))

    current_cabel_k1=0
    current_cabel_k2=0
    current_cabel_k3=0
    current_cabel_i=0
    while(cabels_data_num<=length(CABLES))
        cabels_data_num=cabels_data_num+1
        if cabel_data_num==1 then
            current_cabel_k1=CABLES(cabels_data_num)
        elseif cabel_data_num==2 then
            current_cabel_k2=CABLES(cabels_data_num)
        elseif cabel_data_num==3 then
            current_cabel_k3=CABLES(cabels_data_num)
        elseif cabel_data_num==4 then
            current_cabel_i=CABLES(cabels_data_num)
            cabel_data_num=1
            break
        end;
        cabel_data_num=cabel_data_num+1
     end;

    Iadd=current_cabel_k1*current_cabel_k2*current_cabel_k3*current_cabel_i
    disp(strcat(["Iд.доп=" string(current_cabel_k1) "*" string(current_cabel_k2) "*" string(current_cabel_k3) "*" string(current_cabel_i) "=" string(Iadd)]))

    transfromer_num=transfromer_num+1
end;

// ---------------------------------------------------
//## 2.4 Расчет электрических нагрузок модернизирумоего отдела
// ---------------------------------------------------
disp("2.4 ---------------------------------------------------")

Ploadmax=12
Ploadmin=0.5
m=Ploadmax/Ploadmin
m_formula=strcat(["m=" string(Ploadmax) "/" string(Ploadmin) "=" string(m)])
disp("Показатель силовой сборки в группе электроприемников:",m_formula)

//Pmodern_device_nums=[1.7 4.2 2 0.35 0.19 1 0.1]
Pmodern_device_nums=[3.4 4.2 12 4 0.5]
Kmodern_device_nums_usage=[0.5 0.5 0.5 0.5 0.5]
Cosφ_modern_devices=[0.95 0.75 0.95 0.8 0.95]

disp("Активная компонента мощности:")
modern_device_num=1
Paverages=[]
while(modern_device_num<=length(Pmodern_device_nums))
    // Активная мощность компонента
    Paverage=Pmodern_device_nums(modern_device_num)*Kmodern_device_nums_usage(modern_device_num)
    Paverage_formula=strcat(["Pсм" string(modern_device_num) "=" string(Pmodern_device_nums(modern_device_num)) "*" string(Kmodern_device_nums_usage(modern_device_num)) "=" string(Paverage)])
    disp(Paverage_formula)
    Paverages(modern_device_num)=Paverage

    modern_device_num=modern_device_num+1
end;

disp("Реактивная компонента мощности:")
Tgφ_modern_devices=[]
Qaverages=[]
modern_device_num=1
while(modern_device_num<=length(Paverages))
    // Реактивная компонента мощности
    Tgφ_modern_devices(modern_device_num)=sqrt(1-Cosφ_modern_devices(modern_device_num)^2)/Cosφ_modern_devices(modern_device_num)
    Qaverage=Paverages(modern_device_num)*Tgφ_modern_devices(modern_device_num)
    Qaverage_formula=strcat(["Qсм" string(modern_device_num) "=" string(Paverages(modern_device_num)) "*" string(Tgφ_modern_devices(modern_device_num)) "=" string(Qaverage)])
    disp(Qaverage_formula)
    Qaverages(modern_device_num)=Qaverage

    modern_device_num=modern_device_num+1
end;

disp("Полная мощность за смену для каждого потребителя:")
Tgφ_modern_devices=[]
Saverages=[]
modern_device_num=1
while(modern_device_num<=length(Paverages))
    // Полная мощность
    Saverage=sqrt(Paverages(modern_device_num)^2+Qaverages(modern_device_num)^2)
    Saverage_formula=strcat(["Sсм" string(modern_device_num) "=" "√" string(Paverages(modern_device_num)) "^2" "+" "√" string(Qaverages(modern_device_num)) "^2" "=" string(Saverage)])
    disp(Saverage_formula)
    Saverages(modern_device_num)=Saverage

    modern_device_num=modern_device_num+1
end;

// Формирование данных для формулы эффективного числа электроприемников
modern_device_num=1
Pmodern_device_nums_formula_els=[]
Pmodern_device_nums_squared=[]
Pmodern_device_nums_squared_formula_els=[]
while(modern_device_num<=length(Pmodern_device_nums))
    Pmodern_device_nums_squared(modern_device_num)=Pmodern_device_nums(modern_device_num)^2
    if modern_device_num==1 then
        Pmodern_device_nums_formula_els(modern_device_num)=strcat([string(Pmodern_device_nums(modern_device_num))])
        Pmodern_device_nums_squared_formula_els(modern_device_num)=strcat([string(Pmodern_device_nums(modern_device_num)) "^2"])
    else
        Pmodern_device_nums_formula_els(modern_device_num)=strcat(["+" string(Pmodern_device_nums(modern_device_num))])
        Pmodern_device_nums_squared_formula_els(modern_device_num)=strcat(["+" string(Pmodern_device_nums(modern_device_num)) "^2"])
    end;

    modern_device_num=modern_device_num+1
end;

n_effect=sum(Pmodern_device_nums)^2/sum(Pmodern_device_nums_squared)
n_effect_formula=strcat(["nэ=" "(" strcat(Pmodern_device_nums_formula_els) ")" "^2" "/" strcat(Pmodern_device_nums_squared_formula_els) "=" string(n_effect)])
disp("Значение эффективного числа приёмников:",n_effect_formula)

// Значения коэффициента максимума активной Kм и реактивной Kм мощности
disp("Значения коэффициента максимума активной Kм и реактивной Kм мощности:")
Kaverage=sum(Paverages)/sum(Pmodern_device_nums)
Kaverage_formula=strcat(["Kн.ср=" string(sum(Paverages)) "/" string(sum(Pmodern_device_nums)) "=" string(Kaverage)])
disp(Kaverage_formula)

//Kм’ принимают равным 1,1 при nэ ≤10, и 1,0 при nэ > 10
Km=1+(1.5/sqrt(n_effect))*sqrt((1-Kaverage)/Kaverage)
Km_formula=strcat(["Km=" string(1) "+" "(" string(1.5) "/" "√" string(n_effect) ")" "*" "√" "(" string(1) "-" string(Kaverage) ")" "/" string(Kaverage) "=" string(Km)])
disp(Km_formula)

// Суммарные значения коэффициента мощности
Cosφ_devices_sum=sum(Paverages)/sum(Saverages)
Cosφ_devices_sum_formula=strcat(["cosφ=" string(sum(Paverages)) "/" string(sum(Saverages)) "=" string(Cosφ_devices_sum)])

tgφ_devices_sum=sum(Qaverages)/sum(Paverages)
tgφ_devices_sum_formula=strcat(["tgφ=" string(sum(Qaverages)) "/" string(sum(Paverages)) "=" string(tgφ_devices_sum)])
disp("Суммарные значения коэффициента мощности:",Cosφ_devices_sum_formula,tgφ_devices_sum_formula)

// Максимальная нагрузка и максимальный ток на распределительное устройство
Pm1=Km*sum(Paverages)
Pm1_formula=strcat(["Pm=" string(Km) "*" string(sum(Paverages)) "=" string(Pm1)])

Qm2=1.1*sum(Qaverages)
Qm2_formula=strcat(["Qm=" string(1.1) "*" string(sum(Qaverages)) "=" string(Qm2)])

Sm=sqrt(Pm1^2+Qm2^2)
Sm_formula=strcat(["Sm=" "√" string(Pm1) "^2" "+" string(Qm2) "^2" "=" string(Sm)])

Im=Sm/(sqrt(3)*0.38)
Im_formula=strcat(["Im=" string(Sm) "/" "(" "√" string(3) "*" string(0.38) ")" "=" string(Im)])
disp("Максимальная нагрузка и максимальный ток на распределительное устройство:",Pm1_formula,Qm2_formula,Sm_formula,Im_formula)

// ---------------------------------------------------
//## 2.5 Расчёт дизель-генератора для отделения
// ---------------------------------------------------
disp("2.5 ---------------------------------------------------")

//АД-40С-Т400-2РКМ7
U_GENERATOR=0.4
S_GENERATOR=40

Pgenerator=S_GENERATOR/0.95
Pgenerator_formula=strcat(["Pдг=" string(S_GENERATOR) "/" string(0.95) "=" string(Pgenerator)])
disp(Pgenerator_formula)

// ---------------------------------------------------
//## 2.6 Расчёт освещения модернизируемого отделения
// ---------------------------------------------------
disp("2.6 ---------------------------------------------------")

ROOM_LENGTH=13.5
ROOM_WIDTH=6
ROOM_HEIGHT=2.5
ROOM_S=ROOM_LENGTH*ROOM_WIDTH

LAMP_HEIGHT=0.2
WORK_SURFACE_HEIGHT=1

h_s=ROOM_HEIGHT-(LAMP_HEIGHT+WORK_SURFACE_HEIGHT)
h_s_formula=strcat(["h=" string(ROOM_HEIGHT) "-" "(" string(LAMP_HEIGHT) "+" string(WORK_SURFACE_HEIGHT) ")" "=" string(h_s)])
disp("Высота подвеса светильников:",h_s_formula)

i_r=(ROOM_LENGTH*ROOM_WIDTH)/(h_s*(ROOM_LENGTH+ROOM_WIDTH))
i_r_formula=strcat(["(" string(ROOM_LENGTH) "*" string(ROOM_WIDTH) ")" "/" "(" string(h_s) "*" "(" string(ROOM_LENGTH) "+" string(ROOM_WIDTH) ")" "=" string(i_r)])
disp("Индекс помещения:",i_r_formula)

//0.75 - коэф-ент использования (выбирается по таблице)
LUM_FLUX_UTILIZATION_FACTOR=0.75
LUM_FLUX_MIN=1.15
E_WORK=400
K_STOCK=1
F_LUM=3200
P_LUM_NOM=32
λэ=1.15


//L_distance_in_row=h_s*λэ
//L_distance_in_row_formula=strcat(["L=" string(h_s) "*" string(λэ) "=" string(L_distance_in_row)])
//disp("Расстояние между светильниками в ряду (м):",L_distance_in_row_formula)
//
//Nb=ROOM_WIDTH/L_distance_in_row
//Nb_formula=strcat(["Nb=" string(ROOM_WIDTH) "/" string(L_distance_in_row) "=" string(Nb)])
//disp("Число рядов светильников в помещении:",Nb_formula)
//
//Na=ROOM_LENGTH/L_distance_in_row
//Na_formula=strcat(["Na=" string(ROOM_LENGTH) "/" string(L_distance_in_row) "=" string(Na)])
//disp("Число светильников в ряду:",Na_formula)
//
//Nall=Na*Nb
//Nall_formula=strcat(["Nall=" string(Na) "*" string(Nb) "=" string(Nall)])
//disp("Общее число светильников:",Nall_formula)

Nall=(ROOM_S*E_WORK*K_STOCK*LUM_FLUX_MIN)/(LUM_FLUX_UTILIZATION_FACTOR*F_LUM)
Nall_formula=strcat(["Nall=" "(" string(ROOM_S) "*" string(E_WORK) "*" string(K_STOCK) "*" string(LUM_FLUX_MIN) ")" "/" "(" string(LUM_FLUX_UTILIZATION_FACTOR) "*" string(F_LUM) ")" "=" string(Nall)])
disp("Общее число светильников:",Nall_formula)

//E_ав составляет 15% от E_раб
E_CRASH=E_WORK*(15/100)

Ncrash=(ROOM_S*E_CRASH*K_STOCK*LUM_FLUX_MIN)/(LUM_FLUX_UTILIZATION_FACTOR*F_LUM)
Ncrash_formula=strcat(["Nall=" "(" string(ROOM_S) "*" string(E_CRASH) "*" string(K_STOCK) "*" string(LUM_FLUX_MIN) ")" "/" "(" string(LUM_FLUX_UTILIZATION_FACTOR) "*" string(F_LUM) ")" "=" string(Ncrash)])
disp("Аварийное число светильников:",Ncrash_formula)

K_LUM1=1.1
K_LUM2=0.95

P_lum=K_LUM1*K_LUM2*P_LUM_NOM
P_lum_formula=strcat(["Pp=" string(K_LUM1) "*" string(K_LUM2) "*" string(P_LUM_NOM) "=" string(P_lum)])
disp("Расчётная мощность одного светильника, Вт:",P_lum_formula)

// ---------------------------------------------------
//## 3.1. Расчет токов короткого замыкания
// ---------------------------------------------------
disp("3.1 ---------------------------------------------------")

// Базисные мощности и напряжения
S_BASE=630
U_BASE=10
U_BASE1=0.4
UC_BASE=10.5

// ПвП 3х50/16
// Сопротивление кабельных линий 3х50/16
X_SPECIFIC=0.2 // Электрическое сопротивление кабеля
X_SPECIFIC1=0.64
I_l=0.14 // Длина кабельных линий (км)

X_l=X_SPECIFIC*S_BASE*I_l/U_BASE^2
X_l_formula=strcat(["Xкбл=" string(X_SPECIFIC) "*" string(S_BASE) "*" string(I_l) "/" string(U_BASE) "^2" "=" string(X_l)])

R_l=X_SPECIFIC1*S_BASE*I_l/U_BASE^2
R_l_formula=strcat(["Rкбл=" string(X_SPECIFIC1) "*" string(S_BASE) "*" string(I_l) "/" string(U_BASE) "^2" "=" string(R_l)])
disp("Сопротивление кабельных линий ПвП 3х50/16:",X_l_formula,R_l_formula)

// ВВГ 5х70
// Сопротивление кабельных линий ВВГ 5х70
X_SPECIFIC2=0.0612 // Электрическое сопротивление кабеля
X_SPECIFIC3=0.265
I_l1=0.02 // Длина кабельных линий (км)

X_l1=X_SPECIFIC2*S_BASE*I_l1/U_BASE1^2
X_l1_formula=strcat(["Xкб=" string(X_SPECIFIC2) "*" string(S_BASE) "*" string(I_l1) "/" string(U_BASE1) "^2" "=" string(X_l1)])

R_l2=X_SPECIFIC3*S_BASE*I_l1/U_BASE1^2
R_l2_formula=strcat(["Rкб=" string(X_SPECIFIC3) "*" string(S_BASE) "*" string(I_l1) "/" string(U_BASE1) "^2" "=" string(R_l2)])
disp("Сопротивление кабельных линий ВВГ 5х70:",X_l1_formula,R_l2_formula)

// Сопротивление трансформатора ТП-1 ТМГ-400/10/0,4
X_SPECIFIC4=0.0254

X_t1=(U_BASE1/100)*(S_BASE/S_BASE)
X_t1_formula=strcat(["Xт1=" "(" string(U_BASE1) "/" string(100) ")" "*" "(" string(S_BASE) "/" string(S_BASE) ")" "=" string(X_t1)])

R_t1=(X_SPECIFIC4*S_BASE)/U_BASE1^2
R_t1_formula=strcat(["Rт1=" "(" string(X_SPECIFIC4) "*" string(S_BASE) ")" "/" string(U_BASE1) "^2" "=" string(R_t1)])
disp("Сопротивление трансформатора ТП-1 ТМГ-400/10/0,4:",X_t1_formula,R_t1_formula)

// Сопротивление трансформатора самого высоконагруженного ТП ТМГ-160/6/0,4
//X_SPECIFIC5=0.0417
//
//X_t2=(5.5/100)*(S_BASE/S2_TRANSFORMER)
//X_t2_formula=strcat(["Xт1=" "(" string("5.5") "/" string(100) ")" "*" "(" string(S_BASE) "/" string(S2_TRANSFORMER) ")" "=" string(X_t2)])
//
//R_t2=(X_SPECIFIC4*S_BASE)/S2_TRANSFORMER^2
//R_t2_formula=strcat(["Rт1=" "(" string(X_SPECIFIC4) "*" string(S_BASE) ")" "/" string(S2_TRANSFORMER) "^2" "=" string(R_t2)])
//disp("Сопротивление трансформатора ГПП ТМГ-160/6/0,4:",X_t2_formula,R_t2_formula)

// Расчет токов
Ec=1.05

// КЗ-1
I_sc=Ec/(X_SPECIFIC+X_l)
I_sc_formula=strcat(["Iкз1=" string(Ec) "/" "(" string(X_SPECIFIC) "+" string(X_l) ")" "=" string(I_sc)])

I_b1=S_BASE/(sqrt(3)*U_BASE)
I_b1_formula=strcat(["Iб1=" string(S_BASE) "/" "(" "√" string(3) "*" string(U_BASE) ")" "=" string(I_b1)])

I_no=I_sc*I_b1
I_no_formula=strcat(["Ino=" string(I_sc) "*" string(I_b1) "=" string(I_no)])

I_sc1t=I_no*sqrt(2)
I_sc1t_formula=strcat(["Iкз1т=" string(I_no) "*" "√" string(2) "=" string(I_sc1t)])

// 0.5014 - не знаю откуда взялось значение
// 0.2016 - не знаю откуда взялось значение
Ta1=0.5014/(314*0.2016)
Ta1_formula=strcat(["Tа1=" string(0.5014) "/" "(" string(314) "*" string(0.2016) ")" "=" string(Ta1)])

k_specific=1+2.71828^(-0.01/Ta1)

I_specific1=I_sc1t*k_specific
I_specific1_formula=strcat(["Iуд1=" string(I_sc1t) "*" string(k_specific) "=" string(I_specific1)])
disp("КЗ1:",I_sc_formula,I_b1_formula,I_no_formula,I_sc1t_formula,Ta1_formula,I_specific1_formula)

//I_sc1=Ec/((X_SPECIFIC/2)+(X_l/2)+X_t1)
//I_sc1_formula=strcat(["Iкз2=" string(Ec) "/" "((" string(X_SPECIFIC) "/" string(2) ")" "+" "(" string(X_l) "/" string(2) ")" "+" string(X_t1) "=" string(I_sc1)])

// КЗ-2
I_sc1=Ec/(X_SPECIFIC+X_l+X_l1)
I_sc1_formula=strcat(["Iкз2=" string(Ec) "/" "(" string(X_SPECIFIC) "+" string(X_l) "+" string(X_l1) ")" "=" string(I_sc1)])

I_b2=S_BASE/(sqrt(3)*U_BASE)
I_b2_formula=strcat(["Iб2=" string(S_BASE) "/" "(" "√" string(3) "*" string(U_BASE) ")" "=" string(I_b2)])

I_no1=I_sc1*I_b2
I_no1_formula=strcat(["Ino2=" string(I_sc1) "*" string(I_b2) "=" string(I_no1)])

I_sc2t=I_no1*sqrt(2)
I_sc2t_formula=strcat(["Iкз2т=" string(I_no1) "*" "√" string(2) "=" string(I_sc2t)])

// 0.3559 - не знаю откуда взялось значение
// 0.2568 - не знаю откуда взялось значение
Ta2=0.3559/(314*0.2568)
Ta2_formula=strcat(["Tа2=" string(0.3559) "/" "(" string(314) "*" string(0.2568) ")" "=" string(Ta2)])

k_specific=1+2.71828^(-0.01/Ta2)

I_specific2=I_sc2t*k_specific
I_specific2_formula=strcat(["Iуд2=" string(I_sc2t) "*" string(k_specific) "=" string(I_specific2)])
disp("КЗ2:",I_sc1_formula,I_b2_formula,I_no1_formula,I_sc2t_formula,Ta2_formula,I_specific2_formula)

// КЗ-3
I_sc2=Ec/(X_SPECIFIC+X_l+(X_l1/2)+(X_t1/2))
I_sc2_formula=strcat(["Iкз3=" string(Ec) "/" "(" string(X_SPECIFIC) "+" "(" string(X_l) "/" string(2) ")" "+" "(" string(X_t1) "/" string(2) "))" "=" string(I_sc2)])

I_b3=S_BASE/(sqrt(3)*U_BASE1)
I_b3_formula=strcat(["Iб3=" string(S_BASE) "/" "(" "√" string(3) "*" string(U_BASE1) ")" "=" string(I_b3)])

I_no2=I_sc2*I_b3
I_no2_formula=strcat(["Ino3=" string(I_sc2) "*" string(I_b3) "=" string(I_no2)])

I_sc3t=I_no2*sqrt(2)
I_sc3t_formula=strcat(["Iкз3т=" string(I_no2) "*" "√" string(2) "=" string(I_sc3t)])

// 0.302 - не знаю откуда взялось значение
// 0.2613 - не знаю откуда взялось значение
Ta3=0.302/(314*0.2613)
Ta3_formula=strcat(["Tа2=" string(0.302) "/" "(" string(314) "*" string(0.2613) ")" "=" string(Ta3)])

k_specific=1+2.71828^(-0.01/Ta3)

I_specific3=I_sc3t*k_specific
I_specific3_formula=strcat(["Iуд3=" string(I_sc3t) "*" string(k_specific) "=" string(I_specific3)])
disp("КЗ3:",I_sc2_formula,I_b3_formula,I_no2_formula,I_sc3t_formula,Ta3_formula,I_specific3_formula)

// КЗ-4
//I_sc3=Ec/((X_SPECIFIC/2)+(X_l/2)+(X_t1/2)+X_t1+X_l)
//I_sc3_formula=strcat(["Iкз3=" string(Ec) "/" "((" string(X_SPECIFIC) "/" string(2) ")" "+" "(" string(X_l) "/" string(2) ")" "+" "(" string(X_t1) "/" string(2) ")" "+" string(X_t1) "+" string(X_l) "=" string(I_sc3)])

//I_b4=S_BASE/(sqrt(3)*U_BASE1)
//I_b4_formula=strcat(["Iб4=" string(S_BASE) "/" "(" "√" string(3) "*" string(U_BASE1) ")" "=" string(I_b4)])

//I_no3=I_sc3*I_b4
//I_no3_formula=strcat(["Ino4=" string(I_sc3) "*" string(I_b4) "=" string(I_no3)])

//I_sc4t=I_no3*sqrt(2)
//I_sc4t_formula=strcat(["Iкз4т=" string(I_no3) "*" "√" string(2) "=" string(I_sc4t)])

// 0.6461 - не знаю откуда взялось значение
// 0.2691 - не знаю откуда взялось значение
//Ta4=0.6461/(314*0.2691)
//Ta4_formula=strcat(["Tа2=" string(0.6461) "/" "(" string(314) "*" string(0.2691) ")" "=" string(Ta4)])

//k_specific=1+2.71828^(-0.01/Ta4)

//I_specific4=I_sc4t*k_specific
//I_specific4_formula=strcat(["Iуд4=" string(I_sc4t) "*" string(k_specific) "=" string(I_specific4)])
//disp("КЗ4:",I_sc3_formula,I_b4_formula,I_no3_formula,I_sc4t_formula,Ta4_formula,I_specific4_formula)

// ---------------------------------------------------
//## 3.2. Выбор защитной и коммутационной аппаратуры
// ---------------------------------------------------
disp("3.2 ---------------------------------------------------")

// Выбор разъединителя 10кВ
U_BASE_DISCONNNECTOR=10
I_BASE_DISCONNNECTOR=400
I_BASE_TEMP=16
T_BASE=3

// Термическая стойкость
thermal_resistance=I_BASE_TEMP^2*T_BASE
thermal_resistance_formula=strcat(["Вк=" string(I_BASE_TEMP) "^2" "*" string(T_BASE) "=" string(thermal_resistance)])
disp("Термическая стойкость:", thermal_resistance_formula)

// Выбор предохранителя 10кВ (предохранитель с кварцевым наполнителем серии ПК)













