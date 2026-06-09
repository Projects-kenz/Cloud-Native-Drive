import { Component } from '@angular/core';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterModule],
  template: `
    <nav>
      <span class="brand">🛒 DemoApp</span>
      <a routerLink="/products" routerLinkActive="active">Products</a>
    </nav>
    <router-outlet />
  `,
  styles: [`
    nav { background: #4f46e5; padding: .75rem 1.5rem; display: flex; align-items: center; gap: 1.5rem; }
    .brand { color: #fff; font-weight: 700; font-size: 1.1rem; }
    a { color: #c7d2fe; text-decoration: none; font-size: .95rem; }
    a.active, a:hover { color: #fff; }
  `]
})
export class AppComponent {}
