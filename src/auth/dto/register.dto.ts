import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsString, MinLength } from 'class-validator';

export class RegisterDto {
  @ApiProperty({
    description: 'User full name',
    example: 'John Doe',
    type: String,
  })
  @IsString()
  name: string;

  @ApiProperty({
    description: 'User email address',
    example: 'john.doe@example.com',
    type: String,
  })
  @IsEmail()
  email: string;

  @ApiProperty({
    description: 'User password (minimum 6 characters)',
    example: 'securepassword123',
    minLength: 6,
    type: String,
  })
  @IsString()
  @MinLength(6)
  password: string;
}
