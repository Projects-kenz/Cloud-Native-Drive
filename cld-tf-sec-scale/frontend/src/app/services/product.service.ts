import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Product } from '../models/product.model';
import { environment } from '../../environments/environment';

@Injectable({ providedIn: 'root' })
export class ProductService {
  private readonly url = `${environment.apiUrl}/products`;

  constructor(private http: HttpClient) {}

  getAll(): Observable<Product[]>             { return this.http.get<Product[]>(this.url); }
  getById(id: number): Observable<Product>    { return this.http.get<Product>(`${this.url}/${id}`); }
  create(p: Product): Observable<Product>     { return this.http.post<Product>(this.url, p); }
  update(id: number, p: Product): Observable<void> { return this.http.put<void>(`${this.url}/${id}`, p); }
  delete(id: number): Observable<void>        { return this.http.delete<void>(`${this.url}/${id}`); }
}
