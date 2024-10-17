import { Injectable } from '@nestjs/common';

@Injectable()
export class PrimeFinderService {
  findPrimeNumber(nthNumber: number): number {
    if (nthNumber < 1 || nthNumber == undefined) {
      throw new Error('Nth Number must be greater than 0');
    }

    let count = 0;
    let candidate = 1;

    while (count < nthNumber) {
      candidate++;
      if (this.isPrime(candidate)) {
        count++;
      }
    }
    return candidate;
  }

  private isPrime(num: number): boolean {
    if (num <= 1) return false;
    if (num === 2) return true;
    if (num % 2 === 0) return false;

    const limit = Math.sqrt(num);
    for (let i = 3; i <= limit; i += 2) {
      if (num % i === 0) return false;
    }
    return true;
  }
}
