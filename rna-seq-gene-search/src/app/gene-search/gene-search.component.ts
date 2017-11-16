import { Component, OnInit } from '@angular/core';
import { Gene } from './gene';
import { Experiment } from './experiment';
import { Condition } from './condition';
import { Expression } from './expression';

import { CONDITIONS } from './mock-conditions';
import { EXPRESSIONS } from './mock-expressions';
import { CsvService } from 'angular2-json2csv';
import { GeneService } from './gene.service';
import { ExperimentService } from './experiment.service';
import { ConditionService } from './condition.service';

@Component({
  selector: 'gene-search',
  templateUrl: './gene-search.component.html',
//  styleUrls: ['./gene.component.css']
})
export class GeneSearchComponent implements OnInit {
  title = 'Gene Search Tools';
	genes: Gene[];
	experiments: Experiment[];
	conditions: Condition[];
	expressions: Expression[];
	

	selectedGene: Gene;
	selectedExperiments: Experiment[];
	selectedConditions: Condition[];
	
	dropdownGeneSettings = {};
	dropdownExperimentsSettings = {};
	dropdownConditionsSettings = {};
	
	
	constructor(private csvService: CsvService,
							private geneService: GeneService,
							private experimentService: ExperimentService,
							private conditionService: ConditionService,
							 
							){}
	
	ngOnInit(){
		this.getGenes();
		this.getExperiments(); 
		
		this.selectedGene = null;
		this.dropdownGeneSettings = { 
                                  singleSelection: true, 
                                  text:"Select a Gene",
                                  selectAllText:'Select All',
                                  unSelectAllText:'UnSelect All',
                                  enableSearchFilter: true,
                                  classes:"myclass custom-class",
																	maxHeight: 300,
																	disabled: true,
																	
																	
                                };
		
		this.dropdownExperimentsSettings = {
																	singleSelection: false, 
                                  text:"Select Experiments",
                                  selectAllText:'Select All',
                                  unSelectAllText:'UnSelect All',
                                  enableSearchFilter: true,
                                  classes:"myclass custom-class",
																	maxHeight: 300,
		};
		
		this.dropdownConditionsSettings={
																	singleSelection: false, 
                                  text:"Select Conditions",
                                  selectAllText:'Select All',
                                  unSelectAllText:'UnSelect All',
                                  enableSearchFilter: true,
                                  classes:"myclass custom-class",
																	maxHeight: 300,
																	groupBy: 'experiment_id',
		};
		
		
	}
	
	
	onGeneSelect(item:any){
			console.log(item);
			console.log(this.selectedGene);
	}
	OnGeneDeSelect(item:any){
			console.log(item);
			console.log(this.selectedGene);
	}
	onGeneSelectAll(items: any){
			console.log(items);
	}
	onGeneDeSelectAll(items: any){
			console.log(items);
	}
	
	onExperimentsSelect(item:any){
			console.log(item);
			console.log(this.selectedExperiments);
	}
	OnExperimentsDeSelect(item:any){
			console.log(item);
			console.log(this.selectedExperiments);
	}
	onExperimentsSelectAll(items: any){
			console.log(items);
	}
	onExperimentsDeSelectAll(items: any){
			console.log(items);
	}
	
	onConditionsSelect(item:any){
			console.log(item);
			console.log(this.selectedGene);
	}
	OnConditionsDeSelect(item:any){
			console.log(item);
			console.log(this.selectedGene);
	}
	onConditionsSelectAll(items: any){
			console.log(items);
	}
	onConditionsDeSelectAll(items: any){
			console.log(items);
	}
	
	


	
	getGenes(): void{
		console.log('hello from get genes')
		this.geneService.getGenes2()
				.subscribe(genes => this.genes = genes['genes']);
//		this.genes = this.geneService.getGenes();
	}
	
	 autocompleListFormatter = (data: any) => {
    let test = `<span> ${data.gene_name}</span>`;
    return test;
  }
	
	
	
	getExperiments(): void{
		this.experimentService.getExperiments2()
				.subscribe(experiments => {this.experiments = experiments['experiments']});
	}
	
//	convertExp(experiments): Experiment[]{
//		var exp;
//		var i = 0;
//		experiments = experiments['experiments']
//		var len = experiments.length;
//		var out = [];
//		for (i; i<len; i++){
//			exp = experiments[i];
//			var tmp={};
//			tmp['id'] = exp.id;
//			tmp['itemName'] = exp.description;
//			tmp['comment'] = exp.comments;
//			tmp['species_id'] = exp.species_id;
//			out.push(tmp) 
//		}
//		return(out)
//	}
	
	getConditions(experiments): void {
		
		var exp;
		var i = 0;
		var len = experiments.length;
		for (i; i<len; i++){
			exp = experiments[i];
			this.conditionService.getConditions(exp.id)
					.subscribe(conditions => {this.conditions.push = conditions['conditions']})
		}
		
		
		
//		return(CONDITIONS)
	}
	
	
	
	
	
	downloadExpressions(): void {
		if (this.expressions){
			this.csvService.download(this.expressions, 'test')
		} else {
			alert("please click update button to get expression data")
			console.log("hello from donwload expressions")
		}
		
	}

	getExpressions(): void{
		this.expressions = EXPRESSIONS;
		console.log(this.expressions)	
	}
	
	
	
	
}