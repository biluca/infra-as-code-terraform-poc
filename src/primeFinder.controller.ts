import { Controller, Get, Param } from '@nestjs/common';
import { PrimeFinderService } from './primeFinder.service';

@Controller('prime-finder')
export class PrimeFinderController {
  constructor(private readonly primeFinderService: PrimeFinderService) {}

  @Get('find/:nthNumber')
  findPrimeNumber(@Param('nthNumber') nthNumber): number {
    try {
      return this.primeFinderService.findPrimeNumber(nthNumber);
    } catch (error) {
      return error.message;
    }
  }
}
