import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthModule } from './auth/auth.module';
import { HealthController } from './health/health.controller';
import { TodosModule } from './todos/todos.module';
import { UsersModule } from './users/users.module';

console.log('process.env.DATABASE_HOST', process.env.DATABASE_HOST);
console.log('process.env.DATABASE_PORT', process.env.DATABASE_PORT);
console.log('process.env.DATABASE_USER', process.env.DATABASE_USER);
console.log('process.env.DATABASE_PASSWORD', process.env.DATABASE_PASSWORD);
console.log('process.env.DATABASE_NAME', process.env.DATABASE_NAME);
console.log('process.env.NODE_TLS_REJECT_UNAUTHORIZED', process.env.NODE_TLS_REJECT_UNAUTHORIZED);

@Module({
  imports: [
    ConfigModule.forRoot(),
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: process.env.DATABASE_HOST,
      port: parseInt(process.env.DATABASE_PORT || ''),
      username: process.env.DATABASE_USER,
      password: process.env.DATABASE_PASSWORD,
      database: process.env.DATABASE_NAME,
      autoLoadEntities: true,
      ssl: true,
      synchronize: true, // Don't use this in production
    }),
    AuthModule,
    UsersModule,
    TodosModule,
  ],
  controllers: [HealthController],
})
export class AppModule {}
