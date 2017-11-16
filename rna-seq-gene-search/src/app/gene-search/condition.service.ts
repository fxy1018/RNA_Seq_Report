import { Injectable } from '@angular/core';
import { Observable } from 'rxjs/Observable';
import { of } from 'rxjs/observable/of';
import { HttpClient, HttpHeaders } from '@angular/common/http';

import { Condition } from './condition';
import { GENES } from './mock-genes';

const httpOptions = {
  headers: new HttpHeaders({ 'Content-Type': 'application/json' })
};


@Injectable()

export class ConditionService {
	
	ip = "http://172.20.209.22:3134/";
	conditionsUrl: any;
	
	constructor(
		private http: HttpClient,
	){}


	getConditions(exp_id): Observable<any> {
		this.conditionsUrl = this.ip + "rna_seq/api/v1.0/experiments/"  + exp_id.toString() + "/conditions"
		return this.http.get<any>(this.conditionsUrl)
//			.pipe(
//				catchError(this.handleError('getExperiment2', []))
//		)
	}
}


