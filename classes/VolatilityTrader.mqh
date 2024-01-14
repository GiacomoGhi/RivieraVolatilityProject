
#property copyright "Copyright 2022, Giacomo Ghinelli giacomoghinelli9@gmail.com"
#property link      "https://giacomo-ghinelli.web.app/"

#include <Trade/Trade.mqh>



class VolatilityTrader {
   private: 
      const string symbol;
      const bool isObjectActive;
      const double peakTreshold;
      const int percentBarRange;
      const ENUM_TIMEFRAMES percentBarTimeFrame;
      const int peakRetraceToValidate;
      const int peakRetraceToInvalidate;
      const double oneMicroLotEvery;
      const double TpPoints;
      const int MediationPoints;
      const int mediationMultip;
      const int positionsMax;
      const double emergencyStopAtPercentDD;
      const long Magic;
      const bool useRsi;
      const int overBoughtTh;
      const int overSoldTh;
      const int gridNeededPositions;
      const int gridMaxBars;
      CTrade trade;
      int digit; 
      int totalPositions;
      int tradeDirection; 
      double maxDrowDownValue;
      double peakBottom;
      double peakTop;
      double currentSymbolPnL;
      double point;
      bool longPeak;
      bool shortPeak;
      bool letGridGoLong;
      bool letGridGoShort;
      double totalProfit;
      int tradesNumber;
      int stopLossNumber;
      int tpAtFirstOne;
      int mediationsNumber;
      double swapAccumulated;
      int rsiHandle;
      int openGridBarsNum;
      int barsTotal;
   public:
      VolatilityTrader(
         const string symbolArg,
         const bool isObjectActiveArg,
         const double peakTresholdArg,
         const int percentBarRangeArg,
         const ENUM_TIMEFRAMES percentBarTimeFrameArg,
         const int peakRetraceToValidateArg,
         const int peakRetraceToInvalidateArg,
         const double oneMicroLotEveryArg,
         const double TpPointsArg,
         const int MediationPointsArg,
         const int mediationMultipArg,
         const int positionsMaxArg,
         const double emergencyStopAtPercentDDArg,
         const bool useRsiArg,
         const int overBoughtThArg,
         const int overSoldThArg,
         const int gridNeededPositionsArg,
         const int gridMaxBarsArg,
         const long MagicArg
      ) : 
         symbol(symbolArg),
         isObjectActive(isObjectActiveArg),
         peakTreshold(peakTresholdArg),
         percentBarRange(percentBarRangeArg),
         percentBarTimeFrame(percentBarTimeFrameArg),
         peakRetraceToValidate(peakRetraceToValidateArg),
         peakRetraceToInvalidate(peakRetraceToInvalidateArg),
         oneMicroLotEvery(oneMicroLotEveryArg),
         TpPoints(TpPointsArg),
         MediationPoints(MediationPointsArg),
         mediationMultip(mediationMultipArg),
         positionsMax(positionsMaxArg),
         emergencyStopAtPercentDD(emergencyStopAtPercentDDArg),
         overBoughtTh(overBoughtThArg),
         overSoldTh(overBoughtThArg),
         useRsi(useRsiArg),
         gridNeededPositions(gridNeededPositionsArg),
         gridMaxBars(gridMaxBarsArg),
         Magic(MagicArg)
      {
         if (isObjectActiveArg) {
            this.trade.SetExpertMagicNumber(this.Magic);
            this.letGridGoLong = false;
            this.letGridGoShort = false;
            this.point = SymbolInfoDouble(symbol, SYMBOL_POINT);
            this.digit = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
            this.totalPositions = 0;
            this.maxDrowDownValue = (NormalizeDouble((AccountInfoDouble(ACCOUNT_BALANCE)*(emergencyStopAtPercentDD/100)), 2))*(-1);
            this.totalProfit = 0;
            this.tradesNumber = 0;
            this.stopLossNumber = 0;
            this.tpAtFirstOne = 0;
            this.mediationsNumber = 0;
            this.openGridBarsNum = 0;
            this.swapAccumulated = 0;
            this.rsiHandle = iRSI(this.symbol, PERIOD_W1, 21, PRICE_CLOSE);
         }
         //trade = new CTrade();
      };

   public:
      void onTick();
      void toString();
      bool getStatus();

   private: 
      void getPercentileVariation(int numOfBars, ENUM_TIMEFRAMES timeFrame);
      double calculateLots(int mult, int direction); 
      double biggerSize(int direction);
      void profitMonitor();
      void lossMonitor();
      void gridMediation(bool longMediation, bool shortMediation);
      double calculateMoneyByTpPoints();
      int countPositions(int direction);
      bool rsiIsOk(int direction);
      void gridExpiration(double longProfit, double shortProfit, double profitInPoints);
};

void VolatilityTrader::onTick(){
   if (!isObjectActive) return;

   const int MAX_SPREAD = 20;
   const double spread = NormalizeDouble((SymbolInfoDouble(symbol, SYMBOL_ASK) - SymbolInfoDouble(symbol, SYMBOL_BID)), this.digit);
   const double spreadTH = MAX_SPREAD*point;
   bool isThereAShortPosition = countPositions(0) > 0;
   bool isThereALongPosition = countPositions(1) > 0;
   bool overSold = rsiIsOk(0);
   bool overBought = rsiIsOk(1);

   if(spread < spreadTH && !isThereALongPosition && !isThereAShortPosition){
      getPercentileVariation(percentBarRange, percentBarTimeFrame);
      
      if ((overBought || !useRsi) && longPeak) {         
         trade.Sell(calculateLots(0, 0), symbol, 0, 0, 0);
         letGridGoShort = true;
         longPeak = false;
         this.tradesNumber++;
         return;
      } else if ((overSold || !useRsi) && shortPeak) {         
         trade.Buy(calculateLots(0, 1), symbol, 0, 0, 0);
         letGridGoLong = true;
         shortPeak = false;
         this.tradesNumber++;
         return;
      } 
   }   
   
   if (!isThereAShortPosition) letGridGoShort = false;
   else letGridGoShort = true;
   
   if (!isThereALongPosition) letGridGoLong = false;
   else letGridGoLong = true;

   profitMonitor();
   lossMonitor();
   gridMediation(letGridGoLong, letGridGoShort);

}

bool VolatilityTrader::rsiIsOk(int direction){
   int OVER_BOUGHT = 65;
   int OVER_SOLD = 35;
   double rsiValue[1];
   CopyBuffer(this.rsiHandle, 0, 0, 1, rsiValue);
   double value = rsiValue[0];

   if (direction == 1 && value >= OVER_BOUGHT) {
      return true;
   } else if (direction == 0 && value <= OVER_SOLD) {
      return true;
   } else {
      return false;
   }
}

bool VolatilityTrader::getStatus(){
   return this.isObjectActive;
}

double VolatilityTrader::calculateLots(int mult, int direction) {
   double positionSize = (AccountInfoDouble(ACCOUNT_BALANCE) / this.oneMicroLotEvery) / 100;
   positionSize = NormalizeDouble(positionSize, 2);
   
      if(mult > 0){
         positionSize = biggerSize(direction) * mult;
      };
      
      
   double maxlot = SymbolInfoDouble(this.symbol, SYMBOL_VOLUME_MAX);
   double minlot = SymbolInfoDouble(this.symbol, SYMBOL_VOLUME_MIN);
   

   if (positionSize>=maxlot) positionSize = maxlot;
   else if (positionSize<=minlot) positionSize = minlot;
   
   positionSize = NormalizeDouble(positionSize, 2);

   return positionSize; 
}


double VolatilityTrader::biggerSize(int direction){
   double biggerBuySize = 0;
   double biggerSellSize = 0;
   
   for(int i = PositionsTotal()-1; i >= 0; i--){
      ulong posTicket = PositionGetTicket(i);
      if(PositionSelectByTicket(posTicket)){
         if(PositionGetInteger(POSITION_MAGIC) == Magic && PositionGetString(POSITION_SYMBOL) == this.symbol){
            ENUM_POSITION_TYPE posType = (ENUM_POSITION_TYPE)(PositionGetInteger(POSITION_TYPE));
            if(posType == POSITION_TYPE_BUY && PositionGetDouble(POSITION_VOLUME) > biggerBuySize){
              biggerBuySize =  PositionGetDouble(POSITION_VOLUME);
            }else if(posType == POSITION_TYPE_SELL && PositionGetDouble(POSITION_VOLUME) > biggerSellSize){
              biggerSellSize =  PositionGetDouble(POSITION_VOLUME);
            }
            
         }
      }
   }
   if (direction == 0) return biggerSellSize;
   else return biggerBuySize;
}


double VolatilityTrader::calculateMoneyByTpPoints(){
   double positionSize = (AccountInfoDouble(ACCOUNT_BALANCE) / this.oneMicroLotEvery) / 100;
   double tickSize = SymbolInfoDouble(this.symbol, SYMBOL_TRADE_TICK_SIZE);
   double tickValue = SymbolInfoDouble(this.symbol, SYMBOL_TRADE_TICK_VALUE);
   double lotStep = SymbolInfoDouble(this.symbol, SYMBOL_VOLUME_STEP);

   double moneyLotStep = (this.TpPoints / tickSize) * tickValue * lotStep;

   double moneyProfit = (positionSize * moneyLotStep) / lotStep;

   return NormalizeDouble(moneyProfit, 2);
}

void VolatilityTrader::gridExpiration(double longProfit, double shortProfit, double profitInPoints){
   int bars = iBars(this.symbol, percentBarTimeFrame);
   bool isInProfit = longProfit > profitInPoints || shortProfit > profitInPoints;

   if (barsTotal != bars) {
      barsTotal = bars;

      if (letGridGoLong || letGridGoShort) {
         openGridBarsNum++;
      } else {
         openGridBarsNum = 0;
      }

      if (openGridBarsNum > this.gridMaxBars && isInProfit) {
         for(int i = PositionsTotal()-1; i >= 0; i--){ 
            ulong posTicket = PositionGetTicket(i);
            if(PositionSelectByTicket(posTicket) && (long)PositionGetInteger(POSITION_MAGIC) == Magic && PositionGetString(POSITION_SYMBOL) == this.symbol){
               ulong posTicket = PositionGetTicket(i);
               trade.PositionClose(posTicket);
               this.letGridGoLong = false;  
               this.letGridGoShort = false;
               this.swapAccumulated += PositionGetDouble(POSITION_SWAP);              
            }
         }
      }
   }
}

void VolatilityTrader::profitMonitor(){
   const double MONETARY_PROFT_MEDIATIONS = 1;
   const int MAX_POSITIONS = this.gridNeededPositions;

   const double profitInPoints = this.TpPoints*this.point;
   const double bid = SymbolInfoDouble(this.symbol, SYMBOL_BID);
   const double ask = SymbolInfoDouble(this.symbol, SYMBOL_ASK);
   
   double longPnL = 0;
   double shortPnL = 0;
   double longPointsPnl = 0;
   double shortPointsPnl = 0;
   int longTotalPos = 0;
   int shortTotalPos = 0;

   for(int i = PositionsTotal()-1; i >= 0; i--){
      ulong posTicket = PositionGetTicket(i);
      if(PositionSelectByTicket(posTicket))
         if(PositionGetInteger(POSITION_MAGIC) == Magic && PositionGetString(POSITION_SYMBOL) == this.symbol){
            ENUM_POSITION_TYPE posType = (ENUM_POSITION_TYPE)(PositionGetInteger(POSITION_TYPE));
            
            if(posType == POSITION_TYPE_SELL){
               shortPnL += PositionGetDouble(POSITION_PROFIT);
               shortTotalPos++;
               shortPointsPnl += (PositionGetDouble(POSITION_PRICE_OPEN) - ask)*shortTotalPos;
            };
            
            if(posType == POSITION_TYPE_BUY){
               longPnL += PositionGetDouble(POSITION_PROFIT);
               longTotalPos++;
               longPointsPnl += (bid - PositionGetDouble(POSITION_PRICE_OPEN))*longTotalPos;
            }
            
         }
   }  

   this.totalPositions = longTotalPos + shortTotalPos;
   gridExpiration(longPointsPnl, shortPointsPnl, profitInPoints);
   if(longTotalPos > MAX_POSITIONS && longPointsPnl > profitInPoints  ){ // || (longTotalPos > MAX_POSITIONS && longPnL > MONETARY_PROFT_MEDIATIONS)
      for(int i = PositionsTotal()-1; i >= 0; i--){
         ulong posTicket = PositionGetTicket(i);
         if(PositionSelectByTicket(posTicket))
            if(PositionGetInteger(POSITION_MAGIC) == Magic && PositionGetString(POSITION_SYMBOL) == this.symbol){
               ENUM_POSITION_TYPE posType = (ENUM_POSITION_TYPE)(PositionGetInteger(POSITION_TYPE));
                  if(posType == POSITION_TYPE_BUY){
                     trade.PositionClose(posTicket);
                     this.letGridGoLong = false;
                     this.swapAccumulated += PositionGetDouble(POSITION_SWAP);            
                  }
            }
      } 
      this.maxDrowDownValue = (NormalizeDouble((AccountInfoDouble(ACCOUNT_BALANCE)*(emergencyStopAtPercentDD/100)), 2))*(-1);
      this.totalProfit += longPnL;
      if (longTotalPos == MAX_POSITIONS) {
         this.tpAtFirstOne++;
      }
   }
   
   if(shortTotalPos > MAX_POSITIONS && shortPointsPnl > profitInPoints ){ // || (shortTotalPos > MAX_POSITIONS && shortPnL > MONETARY_PROFT_MEDIATIONS)
      for(int i = PositionsTotal()-1; i >= 0; i--){
         ulong posTicket = PositionGetTicket(i);
         if(PositionSelectByTicket(posTicket))
            if(PositionGetInteger(POSITION_MAGIC) == Magic && PositionGetString(POSITION_SYMBOL) == this.symbol){
               ENUM_POSITION_TYPE posType = (ENUM_POSITION_TYPE)(PositionGetInteger(POSITION_TYPE));
                  if(posType == POSITION_TYPE_SELL){
                     trade.PositionClose(posTicket);
                     this.letGridGoShort = false;
                     this.swapAccumulated += PositionGetDouble(POSITION_SWAP);               
                  }
            }
      } 
      this.maxDrowDownValue = (NormalizeDouble((AccountInfoDouble(ACCOUNT_BALANCE)*(emergencyStopAtPercentDD/100)), 2))*(-1);
      this.totalProfit += shortPnL;
      if (shortTotalPos == MAX_POSITIONS) {
         this.tpAtFirstOne++;
      }
   }
} 


void VolatilityTrader::lossMonitor(){   
   double longPnL = 0;
   double shortPnL = 0;

   for(int i = PositionsTotal()-1; i >= 0; i--){
      ulong posTicket = PositionGetTicket(i);
      if(PositionSelectByTicket(posTicket))
         if(PositionGetInteger(POSITION_MAGIC) == Magic && PositionGetString(POSITION_SYMBOL) == this.symbol){
            ENUM_POSITION_TYPE posType = (ENUM_POSITION_TYPE)(PositionGetInteger(POSITION_TYPE));
            
            if(posType == POSITION_TYPE_SELL){
               shortPnL += PositionGetDouble(POSITION_PROFIT);
            };
            
            if(posType == POSITION_TYPE_BUY){
               longPnL += PositionGetDouble(POSITION_PROFIT);
            }
            
         }
   }  

   shortPnL = NormalizeDouble(shortPnL, 2);
   longPnL = NormalizeDouble(longPnL, 2);

   if (shortPnL < this.maxDrowDownValue || longPnL < this.maxDrowDownValue) {     
      for(int i = PositionsTotal()-1; i >= 0; i--){ 
         ulong posTicket = PositionGetTicket(i);
         if(PositionSelectByTicket(posTicket) && (long)PositionGetInteger(POSITION_MAGIC) == Magic && PositionGetString(POSITION_SYMBOL) == this.symbol){
            ulong posTicket = PositionGetTicket(i);
            trade.PositionClose(posTicket);
            this.letGridGoLong = false;  
            this.letGridGoShort = false;
            this.swapAccumulated += PositionGetDouble(POSITION_SWAP);              
         }
      }
      this.maxDrowDownValue = (NormalizeDouble((AccountInfoDouble(ACCOUNT_BALANCE)*(emergencyStopAtPercentDD/100)), 2))*(-1);
      this.stopLossNumber++;
   }
} 


void VolatilityTrader::getPercentileVariation(int numOfBars, ENUM_TIMEFRAMES timeFrame){
   double peak = iLow(this.symbol, timeFrame, 0);
   double bottom = iHigh(this.symbol, timeFrame, iHighest(this.symbol, timeFrame, MODE_LOW, numOfBars, 0));
   
   if(peak < bottom){   
      double variation = (bottom - peak); 
      double percentVariation = (variation / peak) * 100;
      
      percentVariation = NormalizeDouble(percentVariation, 2);

      if(percentVariation >= this.peakTreshold) {
         this.peakBottom = bottom;
         this.peakTop = peak;
         this.shortPeak = true;
      }  
   }

   peak = iHigh(this.symbol, timeFrame, 0);
   bottom = iLow(this.symbol, timeFrame, iLowest(this.symbol, timeFrame, MODE_HIGH, numOfBars, 0));
   
   if(peak > bottom){
      double variation = (peak - bottom); 

      double percentVariation = (variation / bottom) * 100;

      percentVariation = NormalizeDouble(percentVariation, 2);

      if(percentVariation >= this.peakTreshold) {
         this.peakBottom = bottom;
         this.peakTop = peak;
         this.longPeak = true;
      } 
   }  
   
   return;
} 

void VolatilityTrader::gridMediation(bool longMediation, bool shortMediation){
   double lowestBuyPosPrice = 99937199;
   double highestSellPosPrice = 0;

   int longTradesNum = countPositions(1);
   int shortTradesNum = countPositions(0);
   
   bool longGridIsOk = positionsMax >= longTradesNum;
   bool shortGridIsOk = positionsMax >= shortTradesNum;

   if(longMediation && longGridIsOk){
      for(int i = PositionsTotal()-1; i >= 0; i--){
         ulong posTicket = PositionGetTicket(i);
         if(PositionSelectByTicket(posTicket)){
            if (
               PositionGetInteger(POSITION_MAGIC) == this.Magic && 
               PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY && 
               PositionGetString(POSITION_SYMBOL) == this.symbol
            ){
               double posOpenPrice = PositionGetDouble(POSITION_PRICE_OPEN);
               if(posOpenPrice < lowestBuyPosPrice) lowestBuyPosPrice = posOpenPrice;
            }
         }        
      }
      double bid = SymbolInfoDouble(this.symbol, SYMBOL_BID);
               
      if(bid < (lowestBuyPosPrice - MediationPoints * this.point) && lowestBuyPosPrice != 99937199){
         trade.Buy(this.calculateLots(mediationMultip, 1), this.symbol, 0,0,0, "Med");
         if (longTradesNum == 1) {
            this.mediationsNumber++;
         }
         return;
      }
   } 
   
   lowestBuyPosPrice = 99937199;
   highestSellPosPrice = 0;

   if(shortMediation && shortGridIsOk){
      for(int i = PositionsTotal()-1; i >= 0; i--){
            ulong posTicket = PositionGetTicket(i);
            if(PositionSelectByTicket(posTicket)){
               if (
                  PositionGetInteger(POSITION_MAGIC) == this.Magic && 
                  PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL && 
                  PositionGetString(POSITION_SYMBOL) == this.symbol
               ){
                  double posOpenPrice = PositionGetDouble(POSITION_PRICE_OPEN);
                  if(posOpenPrice > highestSellPosPrice) highestSellPosPrice = posOpenPrice;
               }
            }        
         } 
         double ask = SymbolInfoDouble(this.symbol, SYMBOL_ASK);
         
         if(ask > (highestSellPosPrice + MediationPoints * this.point) && highestSellPosPrice != 0){
            trade.Sell(this.calculateLots(mediationMultip, 0), this.symbol, 0,0,0, "Med");
            if (shortTradesNum == 1) {
               this.mediationsNumber++;
            }
            return;
         }
   }   

}


int VolatilityTrader::countPositions(int direction){
   int buyOpenPositionsLocal = 0;
   int sellOpenPositionsLocal = 0;
   for(int i = PositionsTotal()-1; i >= 0; i--){
      ulong posTicket = PositionGetTicket(i);
      if(PositionSelectByTicket(posTicket))
         if(PositionGetInteger(POSITION_MAGIC) == Magic && PositionGetString(POSITION_SYMBOL) == this.symbol){
            ENUM_POSITION_TYPE posType = (ENUM_POSITION_TYPE)(PositionGetInteger(POSITION_TYPE));
            if(posType == POSITION_TYPE_BUY){
               buyOpenPositionsLocal++;
            }else if(posType == POSITION_TYPE_SELL){
               sellOpenPositionsLocal++;
            }
            
         }
            
   }
   if (direction == 0) return  sellOpenPositionsLocal;
   else return buyOpenPositionsLocal;
}

void VolatilityTrader::toString(){
   Print(
      (string)this.symbol 
      +"\nTotal Profit: "+ (string)this.totalProfit 
      +"\nTotal Trades: "+ (string)this.tradesNumber
      +"\nTotal Stop Losses: "+ (string)this.stopLossNumber 
      +"\nTotal Full TPs: "+ (string)this.tpAtFirstOne
      +"\nTotal Grids Opened: "+ (string)this.mediationsNumber
      +"\nTotal Accumulated Swap interests: "+ (string)this.swapAccumulated
      +"\n"+ "*****************************************"
   );
}
