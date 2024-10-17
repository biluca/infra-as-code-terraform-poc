import { Module } from '@nestjs/common';
import { PrimeFinderController } from './primeFinder.controller';
import { PrimeFinderService } from './primeFinder.service';

@Module({
  imports: [],
  controllers: [PrimeFinderController],
  providers: [PrimeFinderService],
})
export class PrimeFinderModule {}
