import { ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from '../users/user.entity';
import { CreateTodoDto } from './dto/create-todo.dto';
import { UpdateTodoDto } from './dto/update-todo.dto';
import { Todo } from './todo.entity';

@Injectable()
export class TodosService {
  constructor(
    @InjectRepository(Todo)
    private readonly todoRepository: Repository<Todo>,
  ) {}

  async create(createTodoDto: CreateTodoDto, user: User): Promise<Todo> {
    const todo = this.todoRepository.create({ ...createTodoDto, user });
    return this.todoRepository.save(todo);
  }

  async findAll(
    user: User,
    page = 1,
    limit = 10,
  ): Promise<{ data: Todo[]; page: number; limit: number; total: number }> {
    const [data, total] = await this.todoRepository.findAndCount({
      where: { user: { id: user.id } },
      skip: (page - 1) * limit,
      take: limit,
    });
    return { data, page, limit, total };
  }

  async findOne(id: number, user: User): Promise<Todo> {
    const todo = await this.todoRepository.findOne({ where: { id }, relations: ['user'] });
    if (!todo) throw new NotFoundException('Todo not found');
    if (todo.user.id !== user.id) throw new ForbiddenException('Forbidden');
    return todo;
  }

  async update(id: number, updateTodoDto: UpdateTodoDto, user: User): Promise<Todo> {
    const todo = await this.findOne(id, user);
    Object.assign(todo, updateTodoDto);
    return this.todoRepository.save(todo);
  }

  async remove(id: number, user: User): Promise<void> {
    const todo = await this.findOne(id, user);
    await this.todoRepository.remove(todo);
  }
}
