import { NestFactory } from '@nestjs/core';
import { PrimeFinderModule } from './primeFinder.module';

async function bootstrap() {
  const app = await NestFactory.create(PrimeFinderModule);
  await app.listen(8080);
}
bootstrap();
