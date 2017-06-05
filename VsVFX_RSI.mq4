//+------------------------------------------------------------------+
//|                                 VerysVeryInc.MetaTrader4.RSI.mq4 |
//|                  Copyright(c) 2016, VerysVery Inc. & Yoshio.Mr24 |
//|                             https://github.com/Mr24/MetaTrader4/ |
//|                                                 Since:2016.09.24 |
//|                                Released under the Apache license |
//|                       https://opensource.org/licenses/Apache-2.0 |
//|                                                            &     |
//+------------------------------------------------------------------+
//|                                                          RSI.mq4 |
//|                   Copyright 2005-2014, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Copyright(c) 2016 -, VerysVery Inc. && Yoshio.Mr24"
#property link      "https://github.com/VerysVery/MetaTrader4/"
#property description "VsV.MT4.VsVFX_RSI - Ver.2.0.1 Update:2017.06.06"
#property strict


//--- RSI : Initial Setup ---//
#property indicator_separate_window

#property indicator_buffers    1
#property indicator_minimum    0
#property indicator_maximum    100
#property indicator_color1     LimeGreen

//--- RSI : Input Parameters
input int RSIPeriod=14; // RSI Period

//--- RSI : Level Parameters
#property indicator_level1      10.0
#property indicator_level2      20.0
#property indicator_level3      30.0
#property indicator_level4      70.0
#property indicator_level5      80.0
#property indicator_level6      90.0

#property indicator_levelcolor Silver
#property indicator_levelstyle STYLE_DOT

//--- RSI : buffers
double BufRSI[];


//+------------------------------------------------------------------+
//| Custom indicator initialization function (Ver.2.0.1)             |
//+------------------------------------------------------------------+
int OnInit(void)
{
//--- RSI.Initial.Setup ---//
//--- 1 additional buffer used for counting.
  IndicatorBuffers(1);
  SetIndexBuffer( 0, BufRSI );

//*--- RSI.Drawing Settings
  SetIndexStyle( 0, DRAW_LINE );

//*--- RSI.Name for DataWindow & Indicator SubWindow Label
  SetIndexLabel(0, "RSI(" + IntegerToString(RSIPeriod)+")");

//*--- RSI.IndicatorShortName
  IndicatorShortName("RSI(" + IntegerToString(RSIPeriod)+")");

 
//*--- RSI.Check for Input Parameters
  if(RSIPeriod<2)
  {
    Print("Incorrect value for input variable InpRSIPeriod = ",RSIPeriod);
    return(INIT_FAILED);
  }

//---
  SetIndexDrawBegin(0,RSIPeriod);
//--- RSI.Initial.END ---///



//--- RSI.Holizontal.Line.Setup ---//
//+ RSI.Center
ObjectCreate(0, "RSI.Center", OBJ_HLINE, 1, 0, 0);
ObjectSetInteger(0, "RSI.Center", OBJPROP_COLOR, Blue);
ObjectSetInteger(0, "RSI.Center", OBJPROP_BACK, true);

//+ RSI.Top
ObjectCreate(0, "RSI.Top", OBJ_HLINE, 1, 0, 0);
ObjectSetInteger(0, "RSI.Top", OBJPROP_COLOR, Red);
ObjectSetInteger(0, "RSI.Top", OBJPROP_BACK, true);

//+ RSI.Btm
ObjectCreate(0, "RSI.Btm", OBJ_HLINE, 1, 0, 0);
ObjectSetInteger(0, "RSI.Btm", OBJPROP_COLOR, Red);
ObjectSetInteger(0, "RSI.Btm", OBJPROP_BACK, true);

//+ RSI.70
ObjectCreate(0, "RSI.70", OBJ_HLINE, 1, 0, 0);
ObjectSetInteger(0, "RSI.70", OBJPROP_COLOR, Goldenrod);
ObjectSetInteger(0, "RSI.70", OBJPROP_BACK, true);

//+ RSI.30
ObjectCreate(0, "RSI.30", OBJ_HLINE, 1, 0, 0);
ObjectSetInteger(0, "RSI.30", OBJPROP_COLOR, Goldenrod);
ObjectSetInteger(0, "RSI.30", OBJPROP_BACK, true);
//--- RSI.Holizontal.Line.END ---//


//--- initialization done
   return(INIT_SUCCEEDED);
}
//***//


//+------------------------------------------------------------------+
//| Custom Deindicator initialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
  ObjectDelete(0, "RSI.Center");
  ObjectDelete(0, "RSI.Top");
  ObjectDelete(0, "RSI.Btm");
  ObjectDelete(0, "RSI.70");
  ObjectDelete(0, "RSI.30");
}
//***//


//+------------------------------------------------------------------+
//| RSI : Relative Strength Index (Ver.2.0.1)                        |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{

//--- RSI.Calculate.Setup ---//
  int limit=Bars-IndicatorCounted();

  for(int i=limit-1; i>=0; i-- )
  {
      BufRSI[i] = iRSI( NULL, 0, RSIPeriod, PRICE_CLOSE, i );
  }
//--- RSI.Calculate.END ---//


//--- RSI.Holizontal.Line.Setup ---//
ObjectSetDouble(0, "RSI.Center", OBJPROP_PRICE, 50.00);
ObjectSetDouble(0, "RSI.Top", OBJPROP_PRICE, 60.00);
ObjectSetDouble(0, "RSI.Btm", OBJPROP_PRICE, 40.00);
ObjectSetDouble(0, "RSI.70", OBJPROP_PRICE, 70.00);
ObjectSetDouble(0, "RSI.30", OBJPROP_PRICE, 30.00);
//--- RSI.Holizontal.Line.END ---//


//---- OnCalculate done. Return new prev_calculated.
  return(rates_total);
}

//+------------------------------------------------------------------+