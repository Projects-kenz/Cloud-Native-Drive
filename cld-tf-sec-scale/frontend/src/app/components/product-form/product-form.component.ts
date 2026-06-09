import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { ProductService } from '../../services/product.service';
import { Product } from '../../models/product.model';

@Component({
  selector: 'app-product-form',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './product-form.component.html',
  styleUrls: ['./product-form.component.css']
})
export class ProductFormComponent implements OnInit {
  product: Product = { name: '', description: '', price: 0, stock: 0 };
  isEdit = false;
  saving  = false;
  error   = '';

  constructor(
    private svc: ProductService,
    private route: ActivatedRoute,
    private router: Router
  ) {}

  ngOnInit(): void {
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.isEdit = true;
      this.svc.getById(+id).subscribe({
        next: p  => this.product = p,
        error: () => this.error = 'Failed to load product'
      });
    }
  }

  save(): void {
    this.saving = true;
    const obs = this.isEdit
      ? this.svc.update(this.product.id!, this.product)
      : this.svc.create(this.product);

    obs.subscribe({
      next: () => this.router.navigate(['/products']),
      error: err => { this.error = 'Save failed: ' + err.message; this.saving = false; }
    });
  }

  cancel(): void { this.router.navigate(['/products']); }
}
