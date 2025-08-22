import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNumber, IsOptional, IsString } from 'class-validator';

export class CreateUserDto {
  @ApiProperty({
    description: 'User email address',
    example: 'john.doe@example.com',
    type: String,
  })
  @IsEmail()
  email: string;

  @ApiProperty({
    description: 'User full name',
    example: 'John Doe',
    type: String,
  })
  @IsString()
  name: string;

  @ApiProperty({
    description: 'User age (optional)',
    example: 30,
    type: Number,
    required: false,
  })
  @IsOptional()
  @IsNumber()
  age?: number;

  @ApiProperty({
    description: 'User password (minimum 6 characters)',
    example: 'securepassword123',
    minLength: 6,
    type: String,
  })
  @IsString()
  password: string;
}
