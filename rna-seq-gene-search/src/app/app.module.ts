import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';


import { CsvService } from "angular2-json2csv";
import { GeneService } from "./gene-search/gene.service";
import { ExperimentService } from "./gene-search/experiment.service";
import { ConditionService } from "./gene-search/condition.service";

import { HttpClientModule } from '@angular/common/http';

import { AngularMultiSelectModule } from 'angular2-multiselect-dropdown/angular2-multiselect-dropdown';
import {MatButtonModule, 
				MatCheckboxModule,
			 	MatTabsModule,
			} from '@angular/material';
 import { Ng2AutoCompleteModule } from 'ng2-auto-complete';



import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { RouterModule } from '@angular/router';


import { AppComponent } from './app.component';
import { GeneSearchComponent } from './gene-search/gene-search.component';
import { ExpressionDetailComponent } from './gene-search/expression-detail.component';
import { BarchartComponent } from './gene-search/barchart.component';
import { BoxplotComponent } from './gene-search/boxplot.component';
import { DataTableComponent } from './gene-search/data-table.component';

import { AppRoutingModule } from "./app-routing.module";





@NgModule({
  declarations: [
    AppComponent,
		GeneSearchComponent,
		ExpressionDetailComponent,
		BarchartComponent,
		BoxplotComponent,
		DataTableComponent,
		
  ],
  imports: [
    BrowserModule,
		FormsModule,
		BrowserAnimationsModule,		
		AngularMultiSelectModule,
		MatButtonModule, 
		MatCheckboxModule,
		MatTabsModule,
		AppRoutingModule,
		HttpClientModule,
		Ng2AutoCompleteModule
		
  ],
  providers: [ CsvService, GeneService, ExperimentService, ConditionService ],
  bootstrap: [AppComponent]
})
export class AppModule { }
