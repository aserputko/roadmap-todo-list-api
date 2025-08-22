import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString } from 'class-validator';

export class CreateTodoDto {
  @ApiProperty({
    description: 'Todo title',
    example: 'Complete project documentation',
    type: String,
  })
  @IsString()
  @IsNotEmpty()
  title: string;

  @ApiProperty({
    description: 'Todo description',
    example: 'Write comprehensive API documentation for the todo list project',
    type: String,
  })
  @IsString()
  @IsNotEmpty()
  description: string;
}
