import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { Product } from '../../models/product.model';
import { ProductService } from '../../services/product.service';

@Component({
  selector: 'app-product-list',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './product-list.component.html',
  styleUrls: ['./product-list.component.css']
})
export class ProductListComponent implements OnInit {
  products: Product[] = [];
  loading = true;
  error = '';

  constructor(private svc: ProductService) {}

  ngOnInit(): void { this.load(); }

  load(): void {
    this.loading = true;
    this.svc.getAll().subscribe({
      next: data => { this.products = data; this.loading = false; },
      error: err  => { this.error = 'Failed to load products: ' + err.message; this.loading = false; }
    });
  }

  delete(id: number): void {
    if (!confirm('Delete this product?')) return;
    this.svc.delete(id).subscribe({ next: () => this.load(), error: () => alert('Delete failed') });
  }
}
