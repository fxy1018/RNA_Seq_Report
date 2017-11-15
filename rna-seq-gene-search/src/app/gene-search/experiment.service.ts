import { Injectable } from '@angular/core';
import { Observable } from 'rxjs/Observable';
import { of } from 'rxjs/observable/of';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { catchError, map, tap } from 'rxjs/operators';

import { Experiment } from './experiment';
import { EXPERIMENTS } from './mock-experiments';


const httpOptions = {
  headers: new HttpHeaders({ 'Content-Type': 'application/json' })
};


@Injectable()

export class ExperimentService {
	
	private experimentsUrl = "http://172.20.208.246:3134/rna_seq/api/v1.0/experiments"
	
	constructor(
		private http: HttpClient,
	){}
	
	getExperiments(): any {
		return(EXPERIMENTS)
	}
	
	getExperiments2(): Observable<any> {
		return this.http.get<any>(this.experimentsUrl)
//			.pipe(
//				catchError(this.handleError('getExperiment2', []))
//		)
	}
}