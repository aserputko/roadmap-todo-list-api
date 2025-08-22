import { ApiProperty } from '@nestjs/swagger';
import { IsOptional, IsString } from 'class-validator';

export class UpdateTodoDto {
  @ApiProperty({
    description: 'Todo title (optional)',
    example: 'Updated project documentation',
    type: String,
    required: false,
  })
  @IsString()
  @IsOptional()
  title?: string;

  @ApiProperty({
    description: 'Todo description (optional)',
    example: 'Updated comprehensive API documentation for the todo list project',
    type: String,
    required: false,
  })
  @IsString()
  @IsOptional()
  description?: string;
}
