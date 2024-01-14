//+------------------------------------------------------------------+
//|                                                RivieraTrader.mq5 |
//|      Copyright 2022, Giacomo Ghinelli giacomoghinelli9@gmail.com |
//|                                 https://giacomo-ghinelli.web.app |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Giacomo Ghinelli giacomoghinelli9@gmail.com"
#property link      "https://giacomo-ghinelli.web.app"
#property version   "1.00"

#include"./classes/VolatilityTrader.mqh"


input long Magic = 99999;
input double peakTreshold = 0.5;
input int percentBarRange = 20;
input ENUM_TIMEFRAMES percentBarTimeFrame;
input int peakRetraceToValidate = 4;
input int peakRetraceToInvalidate = 3;
input bool useRsi = true;
input int overBoughtTh = 65;
input int overSoldTh = 25;
input int gridNeededPositions = 2;
input double oneMicroLotEvery = 3000;
input double tpPoints = 100;
input int mediationPoints = 1000;
input int mediationMultip = 2;
input int positionsMax = 3;
input int gridMaxBars = 195;
input double emergencyStopAtPercentDD = 15;
input bool eurusd = true;
input bool gbpusd = true;
input bool nzdusd = true;
input bool audusd = true;
input bool usdcad = true;
input bool usdjpy = true;
input bool usdchf = true;
input bool audchf = false;
input bool audjpy = true;
input bool audnzd = false;
input bool cadchf = false;
input bool cadjpy = false;
input bool chfjpy = false;
input bool euraud = true;
input bool eurcad = true;
input bool eurchf = false;
input bool eurgbp = true;
input bool audcad = false;
input bool eurjpy = false;
input bool eurnzd = false;
input bool gbpaud = false;
input bool gbpcad = false;
input bool gbpchf = false;
input bool gbpjpy = false;
input bool gbpnzd = false;
input bool nzdcad = false;
input bool nzdchf = false;
input bool nzdjpy = false;

int k = 1;

VolatilityTrader nzdchfVolTrader(
  "NZDCHF", 
  nzdchf,
  peakTreshold, 
  percentBarRange, 
  percentBarTimeFrame,
  peakRetraceToValidate,
  peakRetraceToInvalidate,
  oneMicroLotEvery,
  tpPoints, 
  mediationPoints,
  mediationMultip,
  positionsMax,
  emergencyStopAtPercentDD,
  useRsi,
  overBoughtTh,
  overSoldTh,
  gridNeededPositions,
  gridMaxBars,
  (Magic)
);

VolatilityTrader nzdcadVolTrader(
  "NZDCAD", 
  nzdcad,
  peakTreshold, 
  percentBarRange, 
  percentBarTimeFrame,
  peakRetraceToValidate,
  peakRetraceToInvalidate,
  oneMicroLotEvery,
  tpPoints, 
  mediationPoints,
  mediationMultip,
  positionsMax,
  emergencyStopAtPercentDD,
  useRsi,
  overBoughtTh,
  overSoldTh,
  gridNeededPositions,
  gridMaxBars,
  (Magic)
);

VolatilityTrader gbpnzdVolTrader(
  "GBPNZD", 
  gbpnzd,
  peakTreshold, 
  percentBarRange, 
  percentBarTimeFrame,
  peakRetraceToValidate,
  peakRetraceToInvalidate,
  oneMicroLotEvery,
  tpPoints, 
  mediationPoints,
  mediationMultip,
  positionsMax,
  emergencyStopAtPercentDD,
  useRsi,
  overBoughtTh,
  overSoldTh,
  gridNeededPositions,
  gridMaxBars,
  (Magic)
);

VolatilityTrader gbpchfVolTrader(
  "GBPCHF", 
  gbpchf,
  peakTreshold, 
  percentBarRange, 
  percentBarTimeFrame,
  peakRetraceToValidate,
  peakRetraceToInvalidate,
  oneMicroLotEvery,
  tpPoints, 
  mediationPoints,
  mediationMultip,
  positionsMax,
  emergencyStopAtPercentDD,
  useRsi,
  overBoughtTh,
  overSoldTh,
  gridNeededPositions,
  gridMaxBars,
  (Magic)
);

VolatilityTrader gbpcadVolTrader(
  "GBPCAD", 
  gbpcad,
  peakTreshold, 
  percentBarRange, 
  percentBarTimeFrame,
  peakRetraceToValidate,
  peakRetraceToInvalidate,
  oneMicroLotEvery,
  tpPoints, 
  mediationPoints,
  mediationMultip,
  positionsMax,
  emergencyStopAtPercentDD,
  useRsi,
  overBoughtTh,
  overSoldTh,
  gridNeededPositions,
  gridMaxBars,
  (Magic)
);

VolatilityTrader gbpaudVolTrader(
  "GBPAUD", 
  gbpaud,
  peakTreshold, 
  percentBarRange, 
  percentBarTimeFrame,
  peakRetraceToValidate,
  peakRetraceToInvalidate,
  oneMicroLotEvery,
  tpPoints, 
  mediationPoints,
  mediationMultip,
  positionsMax,
  emergencyStopAtPercentDD,
  useRsi,
  overBoughtTh,
  overSoldTh,
  gridNeededPositions,
  gridMaxBars,
  (Magic)
);

VolatilityTrader eurnzdVolTrader(
  "EURNZD", 
  eurnzd,
  peakTreshold, 
  percentBarRange, 
  percentBarTimeFrame,
  peakRetraceToValidate,
  peakRetraceToInvalidate,
  oneMicroLotEvery,
  tpPoints, 
  mediationPoints,
  mediationMultip,
  positionsMax,
  emergencyStopAtPercentDD,
  useRsi,
  overBoughtTh,
  overSoldTh,
  gridNeededPositions,
  gridMaxBars,
  (Magic)
);


VolatilityTrader eurchfVolTrader(
  "EURCHF", 
  eurchf,
  peakTreshold, 
  percentBarRange, 
  percentBarTimeFrame,
  peakRetraceToValidate,
  peakRetraceToInvalidate,
  oneMicroLotEvery,
  tpPoints, 
  mediationPoints,
  mediationMultip,
  positionsMax,
  emergencyStopAtPercentDD,
  useRsi,
  overBoughtTh,
  overSoldTh,
  gridNeededPositions,
  gridMaxBars,
  (Magic)
);

VolatilityTrader eurcadVolTrader(
  "EURCAD", 
  eurcad,
  peakTreshold, 
  percentBarRange, 
  percentBarTimeFrame,
  peakRetraceToValidate,
  peakRetraceToInvalidate,
  oneMicroLotEvery,
  tpPoints, 
  mediationPoints,
  mediationMultip,
  positionsMax,
  emergencyStopAtPercentDD,
  useRsi,
  overBoughtTh,
  overSoldTh,
  gridNeededPositions,
  gridMaxBars,
  (Magic)
);

VolatilityTrader chfjpyVolTrader(
  "CHFJPY", 
  chfjpy,
  peakTreshold, 
  percentBarRange, 
  percentBarTimeFrame,
  peakRetraceToValidate,
  peakRetraceToInvalidate,
  oneMicroLotEvery,
  tpPoints, 
  mediationPoints,
  mediationMultip,
  positionsMax,
  emergencyStopAtPercentDD,
  useRsi,
  overBoughtTh,
  overSoldTh,
  gridNeededPositions,
  gridMaxBars,
  (Magic)
);

VolatilityTrader cadjpyVolTrader(
  "CADJPY", 
  cadjpy,
  peakTreshold, 
  percentBarRange, 
  percentBarTimeFrame,
  peakRetraceToValidate,
  peakRetraceToInvalidate,
  oneMicroLotEvery,
  tpPoints, 
  mediationPoints,
  mediationMultip,
  positionsMax,
  emergencyStopAtPercentDD,
  useRsi,
  overBoughtTh,
  overSoldTh,
  gridNeededPositions,
  gridMaxBars,
  (Magic)
);

VolatilityTrader cadchfVolTrader(
  "CADCHF", 
  cadchf,
  peakTreshold, 
  percentBarRange, 
  percentBarTimeFrame,
  peakRetraceToValidate,
  peakRetraceToInvalidate,
  oneMicroLotEvery,
  tpPoints, 
  mediationPoints,
  mediationMultip,
  positionsMax,
  emergencyStopAtPercentDD,
  useRsi,
  overBoughtTh,
  overSoldTh,
  gridNeededPositions,
  gridMaxBars,
  (Magic)
);


VolatilityTrader audnzdVolTrader(
  "AUDNZD", 
  audnzd,
  peakTreshold, 
  percentBarRange, 
  percentBarTimeFrame,
  peakRetraceToValidate,
  peakRetraceToInvalidate,
  oneMicroLotEvery,
  tpPoints, 
  mediationPoints,
  mediationMultip,
  positionsMax,
  emergencyStopAtPercentDD,
  useRsi,
  overBoughtTh,
  overSoldTh,
  gridNeededPositions,
  gridMaxBars,
  (Magic)
);


VolatilityTrader audchfVolTrader(
  "AUDCHF", 
  audchf,
  peakTreshold, 
  percentBarRange, 
  percentBarTimeFrame,
  peakRetraceToValidate,
  peakRetraceToInvalidate,
  oneMicroLotEvery,
  tpPoints, 
  mediationPoints,
  mediationMultip,
  positionsMax,
  emergencyStopAtPercentDD,
  useRsi,
  overBoughtTh,
  overSoldTh,
  gridNeededPositions,
  gridMaxBars,
  (Magic)
);


VolatilityTrader eurusdVolTrader(
  "EURUSD", 
  eurusd,
  peakTreshold, 
  percentBarRange, 
  percentBarTimeFrame,
  peakRetraceToValidate,
  peakRetraceToInvalidate,
  oneMicroLotEvery,
  tpPoints, 
  mediationPoints,
  mediationMultip,
  positionsMax,
  emergencyStopAtPercentDD,
  useRsi,
  overBoughtTh,
  overSoldTh,
  gridNeededPositions,
  gridMaxBars,
  (Magic)
);

VolatilityTrader gbpusdVolTrader(
  "GBPUSD",
  gbpusd, 
  peakTreshold, 
  percentBarRange, 
  percentBarTimeFrame,
  peakRetraceToValidate,
  peakRetraceToInvalidate,
  oneMicroLotEvery,
  tpPoints, 
  mediationPoints,
  mediationMultip,
  positionsMax,
  emergencyStopAtPercentDD,
  useRsi,
  overBoughtTh,
  overSoldTh,
  gridNeededPositions,
  gridMaxBars,
  (Magic)
);

VolatilityTrader usdchfVolTrader(
  "USDCHF",
  usdchf, 
  peakTreshold, 
  percentBarRange, 
  percentBarTimeFrame,
  peakRetraceToValidate,
  peakRetraceToInvalidate,
  oneMicroLotEvery,
  tpPoints, 
  mediationPoints,
  mediationMultip,
  positionsMax,
  emergencyStopAtPercentDD,
  useRsi,
  overBoughtTh,
  overSoldTh,
  gridNeededPositions,
  gridMaxBars,
  (Magic)
);

VolatilityTrader audcadVolTrader(
  "AUDCAD",
  audcad, 
  peakTreshold, 
  percentBarRange, 
  percentBarTimeFrame,
  peakRetraceToValidate,
  peakRetraceToInvalidate,
  oneMicroLotEvery,
  tpPoints, 
  mediationPoints,
  mediationMultip,
  positionsMax,
  emergencyStopAtPercentDD,
  useRsi,
  overBoughtTh,
  overSoldTh,
  gridNeededPositions,
  gridMaxBars,
  (Magic)
);

VolatilityTrader audusdVolTrader(
  "AUDUSD",
  audusd, 
  peakTreshold, 
  percentBarRange, 
  percentBarTimeFrame,
  peakRetraceToValidate,
  peakRetraceToInvalidate,
  oneMicroLotEvery,
  tpPoints, 
  mediationPoints,
  mediationMultip,
  positionsMax,
  emergencyStopAtPercentDD,
  useRsi,
  overBoughtTh,
  overSoldTh,
  gridNeededPositions,
  gridMaxBars,
  (Magic)
);

VolatilityTrader usdcadVolTrader(
  "USDCAD",
  usdcad, 
  peakTreshold, 
  percentBarRange, 
  percentBarTimeFrame,
  peakRetraceToValidate,
  peakRetraceToInvalidate,
  oneMicroLotEvery,
  tpPoints, 
  mediationPoints,
  mediationMultip,
  positionsMax,
  emergencyStopAtPercentDD,
  useRsi,
  overBoughtTh,
  overSoldTh,
  gridNeededPositions,
  gridMaxBars,
  (Magic)
);

VolatilityTrader nzdusdVolTrader(
  "NZDUSD",
  nzdusd, 
  peakTreshold, 
  percentBarRange, 
  percentBarTimeFrame,
  peakRetraceToValidate,
  peakRetraceToInvalidate,
  oneMicroLotEvery,
  tpPoints, 
  mediationPoints,
  mediationMultip,
  positionsMax,
  emergencyStopAtPercentDD,
  useRsi,
  overBoughtTh,
  overSoldTh,
  gridNeededPositions,
  gridMaxBars,
  (Magic)
);

VolatilityTrader euraudVolTrader(
  "EURAUD",
  euraud, 
  peakTreshold, 
  percentBarRange, 
  percentBarTimeFrame,
  peakRetraceToValidate,
  peakRetraceToInvalidate,
  oneMicroLotEvery,
  tpPoints, 
  mediationPoints,
  mediationMultip,
  positionsMax,
  emergencyStopAtPercentDD,
  useRsi,
  overBoughtTh,
  overSoldTh,
  gridNeededPositions,
  gridMaxBars,
  (Magic)
);

VolatilityTrader eurgbpVolTrader(
  "EURGBP",
  eurgbp, 
  peakTreshold, 
  percentBarRange, 
  percentBarTimeFrame,
  peakRetraceToValidate,
  peakRetraceToInvalidate,
  oneMicroLotEvery,
  tpPoints, 
  mediationPoints,
  mediationMultip,
  positionsMax,
  emergencyStopAtPercentDD,
  useRsi,
  overBoughtTh,
  overSoldTh,
  gridNeededPositions,
  gridMaxBars,
  (Magic)
);

VolatilityTrader usdjpyVolTrader(
  "USDJPY",
  usdjpy, 
  peakTreshold, 
  percentBarRange, 
  percentBarTimeFrame,
  peakRetraceToValidate,
  peakRetraceToInvalidate,
  oneMicroLotEvery,
  tpPoints, 
  mediationPoints,
  mediationMultip,
  positionsMax,
  emergencyStopAtPercentDD,
  useRsi,
  overBoughtTh,
  overSoldTh,
  gridNeededPositions,
  gridMaxBars,
  (Magic)
);

VolatilityTrader eurjpyVolTrader(
  "EURJPY",
  eurjpy, 
  peakTreshold, 
  percentBarRange, 
  percentBarTimeFrame,
  peakRetraceToValidate,
  peakRetraceToInvalidate,
  oneMicroLotEvery,
  tpPoints, 
  mediationPoints,
  mediationMultip,
  positionsMax,
  emergencyStopAtPercentDD,
  useRsi,
  overBoughtTh,
  overSoldTh,
  gridNeededPositions,
  gridMaxBars,
  (Magic)
);

VolatilityTrader gbpjpyVolTrader(
  "GBPJPY",
  gbpjpy, 
  peakTreshold, 
  percentBarRange, 
  percentBarTimeFrame,
  peakRetraceToValidate,
  peakRetraceToInvalidate,
  oneMicroLotEvery,
  tpPoints, 
  mediationPoints,
  mediationMultip,
  positionsMax,
  emergencyStopAtPercentDD,
  useRsi,
  overBoughtTh,
  overSoldTh,
  gridNeededPositions,
  gridMaxBars,
  (Magic)
);

VolatilityTrader audjpyVolTrader(
  "AUDJPY",
  audjpy, 
  peakTreshold, 
  percentBarRange, 
  percentBarTimeFrame,
  peakRetraceToValidate,
  peakRetraceToInvalidate,
  oneMicroLotEvery,
  tpPoints, 
  mediationPoints,
  mediationMultip,
  positionsMax,
  emergencyStopAtPercentDD,
  useRsi,
  overBoughtTh,
  overSoldTh,
  gridNeededPositions,
  gridMaxBars,
  (Magic)
);

VolatilityTrader nzdjpyVolTrader(
  "NZDJPY",
  nzdjpy, 
  peakTreshold, 
  percentBarRange, 
  percentBarTimeFrame,
  peakRetraceToValidate,
  peakRetraceToInvalidate,
  oneMicroLotEvery,
  tpPoints, 
  mediationPoints,
  mediationMultip,
  positionsMax,
  emergencyStopAtPercentDD,
  useRsi,
  overBoughtTh,
  overSoldTh,
  gridNeededPositions,
  gridMaxBars,
  (Magic)
);

VolatilityTrader* VolatilityTraders[28] = {
  &eurusdVolTrader,
  &gbpusdVolTrader,
  &usdchfVolTrader,
  &audcadVolTrader,
  &audusdVolTrader,
  &usdcadVolTrader,
  &nzdusdVolTrader,
  &euraudVolTrader,
  &eurgbpVolTrader,
  &usdjpyVolTrader,
  &eurjpyVolTrader,
  &gbpjpyVolTrader,
  &audjpyVolTrader,
  &nzdjpyVolTrader,
  &audchfVolTrader,
  &audnzdVolTrader,
  &cadchfVolTrader,
  &cadjpyVolTrader,
  &chfjpyVolTrader,
  &eurcadVolTrader,
  &eurchfVolTrader,
  &eurnzdVolTrader,
  &gbpaudVolTrader,
  &gbpcadVolTrader,
  &gbpchfVolTrader,
  &gbpnzdVolTrader,
  &nzdcadVolTrader,
  &nzdchfVolTrader
};

const int TRADERS_ARRAY_LENGHT = 28;

int OnInit() {
  return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason){
  for(int i = 0; i < TRADERS_ARRAY_LENGHT; i++){
    if (VolatilityTraders[i].getStatus()) {
      VolatilityTraders[i].toString();
    }
  }    
}

void OnTick(){
  for(int i = 0; i < TRADERS_ARRAY_LENGHT; i++){
    if (VolatilityTraders[i].getStatus()) {
      VolatilityTraders[i].onTick();
    }
  }
}
