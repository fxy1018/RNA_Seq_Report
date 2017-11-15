import { Component, Input, OnInit } from '@angular/core';
import {  ActivatedRoute, ParamMap } from '@angular/router';
import { Location } from '@angular/common';
import 'rxjs/add/operator/switchMap';
import { Router } from '@angular/router';

import { Expression } from './expression';


@Component({
  selector: 'expression-detail',
  templateUrl: './expression-detail.component.html',
//  styleUrls: ['./gene.component.css']
})
export class ExpressionDetailComponent implements OnInit {
  @Input() expressions: Expression[];
	
	routeLinks: any[];
	activeLinkIndex = -1;
	constructor(
		private route: ActivatedRoute,
		private location: Location,
	  private router: Router)
	{
			this.routeLinks  = [
				{
					label: 'Barchart',
					link: './barchart',
					index:0
				},
				{
					label: 'Boxplot',
					link: './boxplot',
					index:1
				},
				{
					label: 'Datatable',
					link: './datatable',
					index:2
				},
			]
	};
	
	ngOnInit(): void {
	};
	
}