import { Injectable, Logger } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {
  private readonly logger = new Logger(JwtAuthGuard.name);

  handleRequest(err: any, user: any, info: any, context: any, status: any) {
    if (err || !user) {
      this.logger.error(
        `Authentication failed: ${err?.message || info?.message || 'No user found'}`,
      );
      this.logger.debug(
        `Request headers: ${JSON.stringify(context.switchToHttp().getRequest().headers)}`,
      );
    } else {
      this.logger.debug(`User authenticated: ${user.email} (ID: ${user.id})`);
    }
    return super.handleRequest(err, user, info, context, status);
  }
}
