import { NgModule }             from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { GeneSearchComponent } from './gene-search/gene-search.component';
import { ExpressionDetailComponent } from './gene-search/expression-detail.component';
import { BarchartComponent } from './gene-search/barchart.component';
import { BoxplotComponent } from './gene-search/boxplot.component';
import { DataTableComponent } from './gene-search/data-table.component';

const routes: Routes = [
	{
		path:'',
		redirectTo:'/gene-search',
		pathMatch: 'full',
	},
	{
		path: 'gene-search', 
		component: GeneSearchComponent,
		children:[
			{path: 'barchart', component: BarchartComponent,},
			{path: 'boxplot', component: BoxplotComponent,},
			{path: 'datatable', component: DataTableComponent,}
			
		]
	},
	
]

@NgModule({
	imports:[ RouterModule.forRoot(routes) ],
	exports:[ RouterModule ],
})

export class AppRoutingModule {}