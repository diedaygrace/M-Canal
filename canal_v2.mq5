//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+ adicionando comentario aqui só pra testar os ramos do github
#include<Trade\Trade.mqh>
CTrade trade;

//--------------------------FUN CANAL-----------------------------------------------------------
int canal = 0, qtCanaisPresentes, contTempoGuardado = 0;
double bufferCanal1 = 0, bufferCanal2 = 0,  razao = 0, idCanaisPresentes[10][4] = {0,0,0,0,0,0,0,0,0,0};
datetime tempoGuardado[11][2] = {0,0,0,0,0,0,0,0,0,0,0}, dataGuardada = 0;
//----------------------------------------------------------------------------------------------
int zigzag1=iCustom(NULL, PERIOD_CURRENT, "Examples\\ZigZag",8,5,3);
int zigzag2=iCustom(NULL, PERIOD_CURRENT, "Examples\\ZigZag",19,5,3);
int zigzag3=iCustom(NULL, PERIOD_CURRENT, "Examples\\ZigZag",36,6,12);
int zigzag4=iCustom(NULL, PERIOD_CURRENT, "Examples\\ZigZag",72,12,24);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   double highs[];            // DECLARAÇÃO DE VARIAVEIS E LISTAS DE INFORMAÇÃO DE PREÇOS \\       [C]
   double lows[];
   double closes[];
   double opens[];
   datetime datas[];
   double Ask;
   double Bid;
   double Balance;
   int Periodo=12;     // PERIODO PARA DETERMINAR A ONDA\\
   long simbolo=StringToInteger(_Symbol);

   ArraySetAsSeries(highs,true);                      // COPIANDO PREÇOS \\         [C]
   CopyHigh(_Symbol,_Period,0,Bars(_Symbol,PERIOD_CURRENT),highs);
   ArraySetAsSeries(lows,true);
   CopyLow(_Symbol,_Period,0,Bars(_Symbol,PERIOD_CURRENT),lows);
   ArraySetAsSeries(closes,true);
   CopyClose(_Symbol,_Period,0,Bars(_Symbol,PERIOD_CURRENT),closes);
   ArraySetAsSeries(opens,true);
   CopyOpen(_Symbol,_Period,0,Bars(_Symbol,PERIOD_CURRENT),opens);
   ArraySetAsSeries(datas,true);
   CopyTime(_Symbol,_Period,0,Bars(_Symbol,PERIOD_CURRENT),datas);
   Ask = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   Bid = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
   Balance=AccountInfoDouble(ACCOUNT_BALANCE);

//indicador zigzag\\
   double buffez1[];
   ArraySetAsSeries(buffez1,true);
   CopyBuffer(zigzag1,0,0,Bars(Symbol(),PERIOD_CURRENT),buffez1);
   double buffez2[];
   ArraySetAsSeries(buffez2,true);
   CopyBuffer(zigzag2,0,0,Bars(Symbol(),PERIOD_CURRENT),buffez2);
   double buffez3[];
   ArraySetAsSeries(buffez3,true);
   CopyBuffer(zigzag3,0,0,Bars(Symbol(),PERIOD_CURRENT),buffez3);
   double buffez4[];
   ArraySetAsSeries(buffez4,true);
   CopyBuffer(zigzag4,0,0,Bars(Symbol(),PERIOD_CURRENT),buffez4);
   
   if(datas[1] != dataGuardada){
      dataGuardada = datas[1];
      FunCanal(simbolo,lows,highs,closes,opens,datas,buffez1);
      FunCanal(simbolo,lows,highs,closes,opens,datas,buffez2);
      FunCanal(simbolo,lows,highs,closes,opens,datas,buffez3);
      FunCanal(simbolo,lows,highs,closes,opens,datas,buffez4);
      if(qtCanaisPresentes > 0) FunCanalRompeu(simbolo,lows,highs);
   }
   

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int FunCanal(long simbolo,double &lows[],double &highs[],double &closes[],double &opens[],datetime &datas[],double &buffez[])
  {
   int candles1a3=2, candles2a4=2, candles3a5=2, candles4a6=2, posPonto1=0, posPonto2=0, posPonto3=0, posPonto4=0, posPonto5=0, posPonto6=0, ponto=0;
   double valPonto1=0, valPonto2=0, valPonto3=0, valPonto4=0, valPonto5=0, valPonto6=0;

   int posTop1=0, posTop3=0, posTop5=0, posFun2=0, posFun4=0, posFun6=0, candlesAux;
   double mediaTop1=0, mediaTop3=0, mediaTop5=0, mediaFun2=0, mediaFun4=0, mediaFun6=0, base1=0, base2=0, base3=0, base4=0, base5=0, base6=0, top1[3], top3[3], top5[3], fun2[3], fun4[3], fun6[3], valAux;

   datetime  tempoAncoraFun2=0,tempoAncoraFun4,tempoAncoraFun6,tempoAncoraTop1,tempoAncoraTop3,tempoAncoraTop5;

   int i=0, j=0;
   for(i=0; i<ArraySize(buffez); i++)
     {
      if(buffez[i]!=0 && i>15)
        {
         ponto++;
         if(ponto==1)
           {
            posPonto1 = i;
            valPonto1 = buffez[i];
              }else{
            if(ponto==2)
              {
               posPonto2 = i;
               valPonto2 = buffez[i];
                 }else{
               if(ponto==3)
                 {
                  posPonto3 = i;
                  valPonto3 = buffez[i];
                    }else{
                  if(ponto==4)
                    {
                     posPonto4 = i;
                     valPonto4 = buffez[i];
                       }else{
                     if(ponto==5)
                       {
                        posPonto5=i;
                          }else{
                        posPonto6=i;
                        break;
                       }
                    }
                 }
              }
           }
           }else{
         if(ponto==1 || ponto==2)
           {
            candles1a3++;
           }
         if(ponto==2 || ponto==3)
           {
            candles2a4++;
           }
         if(ponto==3 || ponto==4)
           {
            candles3a5++;
           }
         if(ponto==4 || ponto==5)
           {
            candles4a6++;
           }
        }
     }

   if(valPonto1>valPonto2 && valPonto3>valPonto4)
     {
      if(closes[posPonto1]>opens[posPonto1])
        {
         base1=closes[posPonto1];
         mediaTop1=((highs[posPonto1]-closes[posPonto1])/2)+closes[posPonto1];
           }else{
         base1=opens[posPonto1];
         mediaTop1=((highs[posPonto1]-opens[posPonto1])/2)+opens[posPonto1];
        }
      if(closes[posPonto3]>opens[posPonto3])
        {
         base3=closes[posPonto3];
         mediaTop3=((highs[posPonto3]-closes[posPonto3])/2)+closes[posPonto3];
           }else{
         base3=opens[posPonto3];
         mediaTop3=((highs[posPonto3]-opens[posPonto3])/2)+opens[posPonto3];
        }
      if(closes[posPonto5]>opens[posPonto5])
        {
         base5=closes[posPonto5];
         mediaTop5=((highs[posPonto5]-closes[posPonto5])/2)+closes[posPonto5];
           }else{
         base5=opens[posPonto5];
         mediaTop5=((highs[posPonto5]-opens[posPonto5])/2)+opens[posPonto5];
        }

      if(closes[posPonto2]<opens[posPonto2])
        {
         base2=closes[posPonto2];
         mediaFun2 = ((closes[posPonto2]-lows[posPonto2])/2)+lows[posPonto2];
           }else{
         base2=opens[posPonto2];
         mediaFun2 = ((opens[posPonto2]-lows[posPonto2])/2)+lows[posPonto2];
        }
      if(closes[posPonto4]<opens[posPonto4])
        {
         base4=closes[posPonto4];
         mediaFun4 = ((closes[posPonto4]-lows[posPonto4])/2)+lows[posPonto4];
           }else{
         base4=opens[posPonto4];
         mediaFun4 = ((opens[posPonto4]-lows[posPonto4])/2)+lows[posPonto4];
        }
      if(closes[posPonto6]<opens[posPonto6])
        {
         base6=closes[posPonto6];
         mediaFun6 = ((closes[posPonto6]-lows[posPonto6])/2)+lows[posPonto6];
           }else{
         base6=opens[posPonto6];
         mediaFun6 = ((opens[posPonto6]-lows[posPonto6])/2)+lows[posPonto6];
        }
      posTop1 = posPonto1;
      posTop3 = posPonto3;
      posTop5 = posPonto5;
      posFun2 = posPonto2;
      posFun4 = posPonto4;
      posFun6 = posPonto6;
        }else{
      if(closes[posPonto2]>opens[posPonto2])
        {
         base1=closes[posPonto2];
         mediaTop1=((highs[posPonto2]-closes[posPonto2])/2)+closes[posPonto2];
           }else{
         base1=opens[posPonto2];
         mediaTop1=((highs[posPonto2]-opens[posPonto2])/2)+opens[posPonto2];
        }
      if(closes[posPonto4]>opens[posPonto4])
        {
         base3=closes[posPonto4];
         mediaTop3=((highs[posPonto4]-closes[posPonto4])/2)+closes[posPonto4];
           }else{
         base3=opens[posPonto4];
         mediaTop3=((highs[posPonto4]-opens[posPonto4])/2)+opens[posPonto4];
        }
      if(closes[posPonto6]>opens[posPonto6])
        {
         base5=closes[posPonto6];
         mediaTop5=((highs[posPonto6]-closes[posPonto6])/2)+closes[posPonto6];
           }else{
         base5=opens[posPonto6];
         mediaTop5=((highs[posPonto6]-opens[posPonto6])/2)+opens[posPonto6];
        }

      if(closes[posPonto1]<opens[posPonto1])
        {
         base2=closes[posPonto1];
         mediaFun2 = ((closes[posPonto1]-lows[posPonto1])/2)+lows[posPonto1];
           }else{
         base2=opens[posPonto1];
         mediaFun2 = ((opens[posPonto1]-lows[posPonto1])/2)+lows[posPonto1];
        }
      if(closes[posPonto3]<opens[posPonto3])
        {
         base4=closes[posPonto3];
         mediaFun4 = ((closes[posPonto3]-lows[posPonto3])/2)+lows[posPonto3];
           }else{
         base4=opens[posPonto3];
         mediaFun4 = ((opens[posPonto3]-lows[posPonto3])/2)+lows[posPonto3];
        }
      if(closes[posPonto5]<opens[posPonto5])
        {
         base6=closes[posPonto5];
         mediaFun6 = ((closes[posPonto5]-lows[posPonto5])/2)+lows[posPonto5];
           }else{
         base6=opens[posPonto5];
         mediaFun6 = ((opens[posPonto5]-lows[posPonto5])/2)+lows[posPonto5];
        }
      posTop1 = posPonto2;
      posTop3 = posPonto4;
      posTop5 = posPonto6;
      posFun2 = posPonto1;
      posFun4 = posPonto3;
      posFun6 = posPonto5;
      candlesAux = candles1a3;
      candles1a3 = candles2a4;
      candles2a4 = candlesAux;
      candlesAux = candles3a5;
      candles3a5 = candles4a6;
      candles4a6 = candlesAux;
      valAux=valPonto1;
      valPonto1 = valPonto2;
      valPonto2 = valAux;
      valAux=valPonto3;
      valPonto3 = valPonto4;
      valPonto4 = valAux;
     }
   top1[0] = base1;
   top1[1] = mediaTop1;
   top1[2] = highs[posTop1];
   top3[0] = base3;
   top3[1] = mediaTop3;
   top3[2] = highs[posTop3];
   top5[0] = base5;
   top5[1] = mediaTop5;
   top5[2] = highs[posTop5];
   fun2[0] = base2;
   fun2[1] = mediaFun2;
   fun2[2] = lows[posFun2];
   fun4[0] = base4;
   fun4[1] = mediaFun4;
   fun4[2] = lows[posFun4];
   fun6[0] = base6;
   fun6[1] = mediaFun6;
   fun6[2] = lows[posFun6];
   tempoAncoraFun2 = datas[posFun2];
   tempoAncoraFun4 = datas[posFun4];
   tempoAncoraFun6 = datas[posFun6];
   tempoAncoraTop1 = datas[posTop1];
   tempoAncoraTop3 = datas[posTop3];
   tempoAncoraTop5 = datas[posTop5];

   if(FunCanalEncontrar(tempoAncoraFun2,tempoAncoraFun4,tempoAncoraTop1,tempoAncoraTop3,fun2,fun4,top1,top3,highs,lows,base2,//1
      base4, candles1a3, candles2a4, posFun2, posFun4, posTop1, posTop3, simbolo) == 1) return 1;

   if(FunCanalEncontrar(tempoAncoraFun2,tempoAncoraFun6,tempoAncoraTop1,tempoAncoraTop3,fun2,fun6,top1,top3,highs,lows,base2,//2
      base6, candles1a3, (candles2a4+candles4a6-1), posFun2, posFun6, posTop1, posTop3, simbolo) == 1) return 1;

   if(FunCanalEncontrar(tempoAncoraFun2,tempoAncoraFun4,tempoAncoraTop1,tempoAncoraTop5,fun2,fun4,top1,top5,highs,lows,base2,//3
      base4, (candles1a3+candles3a5-1), candles2a4, posFun2, posFun4, posTop1, posTop5, simbolo) == 1) return 1;

   if(FunCanalEncontrar(tempoAncoraFun2,tempoAncoraFun6,tempoAncoraTop1,tempoAncoraTop5,fun2,fun6,top1,top5,highs,lows,base2,//4
      base6, (candles1a3+candles3a5-1), (candles2a4+candles4a6-1), posFun2, posFun6, posTop1, posTop5, simbolo) == 1) return 1;


//[...]
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int FunMostrarCanal(long simbolo,int canais,datetime tempo2,double preco2,datetime tempo4,double preco4,datetime tempo1,double preco1,datetime tempo3,double preco3, bool metodo)
  {
   datetime extra=21000; //15 candle de 5 miniutos

   if(!ObjectCreate(simbolo,IntegerToString(canais)+" Parte Inferior ",OBJ_TREND,0,tempo2+extra,preco2+razao*70,tempo4,preco4))
     {
      return 0;
     }
   if(!ObjectCreate(simbolo,IntegerToString(canais)+" Parte Superior ",OBJ_TREND,0,tempo1+extra,preco1+razao*70,tempo3,preco3))
     {
      return 0;
     }
   if(metodo==false){
      ObjectSetInteger(simbolo,IntegerToString(canais)+" Parte Inferior ",OBJPROP_COLOR,clrBlue);
      ObjectSetInteger(simbolo,IntegerToString(canais)+" Parte Inferior ",OBJPROP_WIDTH,2);
      
      ObjectSetInteger(simbolo,IntegerToString(canais)+" Parte Superior ",OBJPROP_COLOR,clrYellow);
      ObjectSetInteger(simbolo,IntegerToString(canais)+" Parte Superior ",OBJPROP_WIDTH,2);
   }else{
      ObjectSetInteger(simbolo,IntegerToString(canais)+" Parte Inferior ",OBJPROP_COLOR,clrRed);
      ObjectSetInteger(simbolo,IntegerToString(canais)+" Parte Inferior ",OBJPROP_WIDTH,2);
      
      ObjectSetInteger(simbolo,IntegerToString(canais)+" Parte Superior ",OBJPROP_COLOR,clrGreen);
      ObjectSetInteger(simbolo,IntegerToString(canais)+" Parte Superior ",OBJPROP_WIDTH,2);
   }
   ObjectCreate(simbolo,IntegerToString(canais)+" Eclipse Inferior 1 ",OBJ_ELLIPSE,0,tempo2-350,preco2,tempo2+350,preco2,tempo2,preco2+(25*Point()));
   ObjectSetInteger(simbolo,IntegerToString(canais)+" Eclipse Inferior 1 ",OBJPROP_FILL,true);
   ObjectSetInteger(simbolo,IntegerToString(canais)+" Eclipse Inferior 1 ",OBJPROP_COLOR,clrBlue);
   
   ObjectCreate(simbolo,IntegerToString(canais)+" Eclipse Inferior 2 ",OBJ_ELLIPSE,0,tempo4-350,preco4,tempo4+350,preco4,tempo4,preco4+(25*Point()));
   ObjectSetInteger(simbolo,IntegerToString(canais)+" Eclipse Inferior 2 ",OBJPROP_FILL,true);
   ObjectSetInteger(simbolo,IntegerToString(canais)+" Eclipse Inferior 2 ",OBJPROP_COLOR,clrBlue);
   
   
   ObjectCreate(simbolo,IntegerToString(canais)+" Eclipse Superior 1 ",OBJ_ELLIPSE,0,tempo1-350,preco1,tempo1+350,preco1,tempo1,preco1+(25*Point()));
   ObjectSetInteger(simbolo,IntegerToString(canais)+" Eclipse Superior 1 ",OBJPROP_FILL,true);
   ObjectSetInteger(simbolo,IntegerToString(canais)+" Eclipse Superior 1 ",OBJPROP_COLOR,clrYellow);
   
   ObjectCreate(simbolo,IntegerToString(canais)+" Eclipse Superior 2 ",OBJ_ELLIPSE,0,tempo3-350,preco3,tempo3+350,preco3,tempo3,preco3+(25*Point()));
   ObjectSetInteger(simbolo,IntegerToString(canais)+" Eclipse Superior 2 ",OBJPROP_FILL,true);
   ObjectSetInteger(simbolo,IntegerToString(canais)+" Eclipse Superior 2 ",OBJPROP_COLOR,clrYellow);

   return 1;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int FunCanalEncontrar(datetime tempoAncoraY1,datetime tempoAncoraY2,datetime tempoAncoraX1,datetime tempoAncoraX2, double &funY1[], double &funY2[],
                      double &topX1[],double &topX2[],double &highs[],double &lows[],double baseY1,double baseY2,int candlesX1aX2,int candlesY1aY2,int posY1,int posY2,int posX1,int posX2,long simbolo)
  {

   double precoAncoraX1=0,precoAncoraX2=0,precoAncoraY1=0,precoAncoraY2=0;
   double veriMenu,veriBase,veriExtre;
   int i=0,j=0,k=0;
   bool nao=false;

   for(i=0; i<3; i++)
     {
      for(j=0; j<3; j++)
        {
         razao=(topX1[i]-topX2[j])/(candlesX1aX2);
         if(razao<0)
           {
            veriMenu=razao*-candlesY1aY2;
              }else{
            veriMenu=razao*candlesY1aY2;
           }
         if(baseY1>baseY2)
           {
            veriBase=baseY1-baseY2;
              }else{
            veriBase=baseY2-baseY1;
           }
         if(lows[posY1]>lows[posY2])
           {
            veriExtre=lows[posY1]-lows[posY2];
              }else{
            veriExtre=lows[posY2]-lows[posY1];
           }
         k=0;
         while(tempoGuardado[k][0] != 0){
            if(tempoAncoraY1==tempoGuardado[k][0] || tempoAncoraX1==tempoGuardado[k][1] ){
               nao=true;
               break;
            }
            k++;
         }
         if((veriBase>=veriMenu && veriMenu>=veriExtre) && nao==false && ((razao>=0 && baseY1>=baseY2) || (razao<0 && baseY1<baseY2)))
           {
            precoAncoraX1=topX1[i];
            precoAncoraX2=topX2[j];
            if((baseY1-lows[posY1])<(baseY2-lows[posY2]))
              {
               precoAncoraY1=baseY1;
               precoAncoraY2=(candlesY1aY2*(razao-(2*razao))+baseY1);
                 }else{
               precoAncoraY2=baseY2;
               precoAncoraY1=(candlesY1aY2*razao)+baseY2;
              }
            for(k=posY1; k<posY2; k++)
              {
               if(highs[k]<precoAncoraY1-(razao*(k-posY1+1)))
                 {
                  nao=true;
                  break;
                 }
              }
            if(nao==false)
              {
               for(k=posX1; k<posX2; k++)
                 {
                  if(lows[k]>precoAncoraX1-(razao*(k-posX1+1)))
                    {
                     nao=true;
                     break;
                    }
                 }
              }
            if(nao==false)
              {
               canal++;
               bufferCanal1=(posX1*razao)+precoAncoraX1;
               bufferCanal2=(posY1*razao)+precoAncoraY1;
               
               qtCanaisPresentes++;
               idCanaisPresentes[qtCanaisPresentes][0] = canal;
               idCanaisPresentes[qtCanaisPresentes][1] = bufferCanal1;
               idCanaisPresentes[qtCanaisPresentes][2] = bufferCanal2;
               idCanaisPresentes[qtCanaisPresentes][3] = razao;
               
               tempoGuardado[contTempoGuardado][0]=tempoAncoraY1;
               tempoGuardado[contTempoGuardado][1]=tempoAncoraX1;
               contTempoGuardado++;
               if(contTempoGuardado==10) contTempoGuardado=0;
               FunMostrarCanal(simbolo,canal,tempoAncoraY1,precoAncoraY1,tempoAncoraY2,precoAncoraY2,tempoAncoraX1,precoAncoraX1,tempoAncoraX2,precoAncoraX2,false);
               Print("buffer1: ", bufferCanal1);
               Print("buffer2: ", bufferCanal2);
               return 1;
              }
           }
        }
     }
     
     for(i=0; i<3; i++)
     {
      for(j=0; j<3; j++)
        {
         razao=(funY1[i]-funY2[j])/(candlesY1aY2);
         if(razao<0)
           {
            veriMenu=razao*-candlesX1aX2;
              }else{
            veriMenu=razao*candlesX1aX2;
           }
         if(topX1[0]>topX2[0])
           {
            veriBase=topX1[0]-topX2[0];
              }else{
            veriBase=topX2[0]-topX1[0];
           }
         if(highs[posX1]>highs[posX2])
           {
            veriExtre=highs[posX1]-highs[posX2];
           }else{
            veriExtre=highs[posX2]-highs[posX1];
           }
         k=0;
         while(tempoGuardado[k][0] != 0){
            if(tempoAncoraY1==tempoGuardado[k][0] || tempoAncoraX1==tempoGuardado[k][1] ){
               nao=true;
               break;
            }
            k++;
         }
         if((veriBase<=veriMenu && veriMenu<=veriExtre) && nao==false && ((razao>=0 && topX1[0]>=topX2[0]) || (razao<0 && topX1[0]<topX2[0])))
           {
            precoAncoraY1=funY1[i];
            precoAncoraY2=funY2[j];
            if((highs[posX1]-topX1[0])<(highs[posX2]-topX2[0]))
              {
               precoAncoraX1=topX1[0];
               precoAncoraX2=(candlesX1aX2*(razao-(2*razao))+topX1[0]);
                 }else{
               precoAncoraX2=topX2[0];
               precoAncoraX1=(candlesX1aX2*razao)+topX2[0];
              }
            for(k=posY1; k<posY2; k++)
              {
               if(highs[k]<precoAncoraY1-(razao*(k-posY1+1)))
                 {
                  nao=true;
                  break;
                 }
              }
            if(nao==false)
              {
               for(k=posX1; k<posX2; k++)
                 {
                  if(lows[k]>precoAncoraX1-(razao*(k-posX1+1)))
                    {
                     nao=true;
                     break;
                    }
                 }
              }
            if(nao==false)
               {
                  canal++;
                  bufferCanal1=(posX1*razao)+precoAncoraX1;
                  bufferCanal2=(posY1*razao)+precoAncoraY1;
                  
                  qtCanaisPresentes++;
                  idCanaisPresentes[qtCanaisPresentes][0] = canal;
                  idCanaisPresentes[qtCanaisPresentes][1] = bufferCanal1;
                  idCanaisPresentes[qtCanaisPresentes][2] = bufferCanal2;
                  idCanaisPresentes[qtCanaisPresentes][3] = razao;
                  
                  tempoGuardado[contTempoGuardado][0]=tempoAncoraY1;
                  tempoGuardado[contTempoGuardado][1]=tempoAncoraX1;
                  contTempoGuardado++;
                  if(contTempoGuardado==10) contTempoGuardado=0;
                  FunMostrarCanal(simbolo,canal,tempoAncoraY1,precoAncoraY1,tempoAncoraY2,precoAncoraY2,tempoAncoraX1,precoAncoraX1,tempoAncoraX2,precoAncoraX2,true);
                  Print("buffer1: ", bufferCanal1);
                  Print("buffer2: ", bufferCanal2);
                  return 1;
               }
           }
        }
     }
   return 0;
  }
//+------------------------------------------------------------------+
bool FunCanalRompeu(long simbolo, double &lows[], double &highs[]){
   int cont = 1, contAux = 0;
   bool retirou = false;
   
   while(idCanaisPresentes[cont][0] != 0 && cont<10){
      if(idCanaisPresentes[cont][1]+idCanaisPresentes[cont][3] < lows[1] || idCanaisPresentes[cont][2]+idCanaisPresentes[cont][3] > highs[1]){
         Print(DoubleToString(idCanaisPresentes[cont][0],0)+" Parte Inferior ");
         ObjectSetInteger(simbolo,DoubleToString(idCanaisPresentes[cont][0],0)+" Parte Inferior ",OBJPROP_COLOR,C'020,020,020');
         ObjectSetInteger(simbolo,DoubleToString(idCanaisPresentes[cont][0],0)+" Parte Superior ",OBJPROP_COLOR,C'020,020,020');
         ObjectSetInteger(simbolo,DoubleToString(idCanaisPresentes[cont][0],0)+" Eclipse Inferior 1 ",OBJPROP_COLOR,C'020,020,020');
         ObjectSetInteger(simbolo,DoubleToString(idCanaisPresentes[cont][0],0)+" Eclipse Inferior 2 ",OBJPROP_COLOR,C'020,020,020');
         ObjectSetInteger(simbolo,DoubleToString(idCanaisPresentes[cont][0],0)+" Eclipse Superior 1 ",OBJPROP_COLOR,C'020,020,020');
         ObjectSetInteger(simbolo,DoubleToString(idCanaisPresentes[cont][0],0)+" Eclipse Superior 2 ",OBJPROP_COLOR,C'020,020,020');
         ObjectSetInteger(simbolo,DoubleToString(idCanaisPresentes[cont][0],0)+" Parte Inferior ",OBJPROP_WIDTH,1);
         ObjectSetInteger(simbolo,DoubleToString(idCanaisPresentes[cont][0],0)+" Parte Superior ",OBJPROP_WIDTH,1);
         idCanaisPresentes[cont][0] = 0;
         idCanaisPresentes[cont][1] = 0;
         idCanaisPresentes[cont][2] = 0;
         idCanaisPresentes[cont][3] = 0;
         
         contAux = cont;
         while(idCanaisPresentes[contAux+1][0] != 0 || contAux+1 == 10){
            idCanaisPresentes[contAux][0] = idCanaisPresentes[contAux+1][0];
            idCanaisPresentes[contAux][1] = idCanaisPresentes[contAux+1][1];
            idCanaisPresentes[contAux][2] = idCanaisPresentes[contAux+1][2];
            contAux++;
         }
         idCanaisPresentes[contAux][0] = 0;
         idCanaisPresentes[contAux][1] = 0;
         idCanaisPresentes[contAux][2] = 0;
         
         contAux = 0;
         qtCanaisPresentes--;
         retirou = true;
         continue;
      }else{
         idCanaisPresentes[cont][1] = idCanaisPresentes[cont][1]+idCanaisPresentes[cont][3];
         idCanaisPresentes[cont][2] = idCanaisPresentes[cont][2]+idCanaisPresentes[cont][3];
      }
      cont++;
   }
   return retirou;
}