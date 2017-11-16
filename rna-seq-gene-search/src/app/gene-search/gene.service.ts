import { Injectable } from '@angular/core';
import { Observable } from 'rxjs/Observable';
import { of } from 'rxjs/observable/of';
import { HttpClient, HttpHeaders } from '@angular/common/http';

import { Gene } from './gene';
import { GENES } from './mock-genes';

const httpOptions = {
  headers: new HttpHeaders({ 'Content-Type': 'application/json' })
};


@Injectable()

export class GeneService {
	
	private genesUrl = "http://172.20.209.22:3134/rna_seq/api/v1.0/genes"
	
	constructor(
		private http: HttpClient,
	){}
	getGenes(): Observable<Gene[]> {
		return of(GENES);
	}

	getGenes2(): Observable<any> {
		return this.http.get<any>(this.genesUrl)
//			.pipe(
//				catchError(this.handleError('getExperiment2', []))
//		)
	}
}
