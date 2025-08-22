import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  Param,
  Post,
  Put,
  Query,
  Request,
  UseGuards,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiBody,
  ApiOperation,
  ApiParam,
  ApiQuery,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CreateTodoDto } from './dto/create-todo.dto';
import { UpdateTodoDto } from './dto/update-todo.dto';
import { TodosService } from './todos.service';

@ApiTags('todos')
@ApiBearerAuth('JWT-auth')
@Controller('todos')
@UseGuards(JwtAuthGuard)
export class TodosController {
  constructor(private readonly todosService: TodosService) {}

  @Post()
  @ApiOperation({ summary: 'Create a new todo' })
  @ApiBody({ type: CreateTodoDto })
  @ApiResponse({ status: 201, description: 'Todo created successfully' })
  @ApiResponse({ status: 400, description: 'Bad request' })
  @ApiResponse({ status: 401, description: 'Unauthorized' })
  async create(@Body() createTodoDto: CreateTodoDto, @Request() req) {
    const todo = await this.todosService.create(createTodoDto, req.user);
    return { id: todo.id, title: todo.title, description: todo.description };
  }

  @Get()
  @ApiOperation({ summary: 'Get all todos for the authenticated user' })
  @ApiQuery({ name: 'page', required: false, description: 'Page number', example: 1 })
  @ApiQuery({ name: 'limit', required: false, description: 'Items per page', example: 10 })
  @ApiResponse({ status: 200, description: 'Todos retrieved successfully' })
  @ApiResponse({ status: 401, description: 'Unauthorized' })
  async findAll(@Request() req, @Query('page') page = 1, @Query('limit') limit = 10) {
    return this.todosService.findAll(req.user, Number(page), Number(limit));
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update a todo' })
  @ApiParam({ name: 'id', description: 'Todo ID', example: 1 })
  @ApiBody({ type: UpdateTodoDto })
  @ApiResponse({ status: 200, description: 'Todo updated successfully' })
  @ApiResponse({ status: 400, description: 'Bad request' })
  @ApiResponse({ status: 401, description: 'Unauthorized' })
  @ApiResponse({ status: 404, description: 'Todo not found' })
  async update(@Param('id') id: number, @Body() updateTodoDto: UpdateTodoDto, @Request() req) {
    const todo = await this.todosService.update(Number(id), updateTodoDto, req.user);
    return { id: todo.id, title: todo.title, description: todo.description };
  }

  @Delete(':id')
  @HttpCode(204)
  @ApiOperation({ summary: 'Delete a todo' })
  @ApiParam({ name: 'id', description: 'Todo ID', example: 1 })
  @ApiResponse({ status: 204, description: 'Todo deleted successfully' })
  @ApiResponse({ status: 401, description: 'Unauthorized' })
  @ApiResponse({ status: 404, description: 'Todo not found' })
  async remove(@Param('id') id: number, @Request() req) {
    await this.todosService.remove(Number(id), req.user);
  }
}
