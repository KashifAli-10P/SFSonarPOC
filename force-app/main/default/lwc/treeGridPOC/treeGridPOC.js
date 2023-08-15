import { LightningElement, track } from 'lwc';
import getContacts from '@salesforce/apex/GetContactsTree.getContacts'
export default class TreeGridPOC extends LightningElement {
    gridColumns = [
        {
            type: 'text',
            fieldName: 'FirstName',
            label: 'First Name',
        },
        {
            type: 'text',
            fieldName: 'LastName',
            label: 'Last Name',
        },
        {
            type: 'email',
            fieldName: 'Email',
            label: 'Email',
        },
        {
            type: 'text',
            fieldName: 'AccountId',
            label: 'Account',
        }
    ];

    @track gridData = [];
    @track data = [];
    startingRecord;
    endingRecord;
    totalRecountCount;
    previousBtnDisable;
    nextBtnDisable;
    totalPage;
    endingRecord;
    pageSize = 5;
    page;

    connectedCallback() {
        getContacts().then(result => {
            this.data = result;
            this.totalRecountCount = result.length;
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);
            this.gridData = result.slice(0, this.pageSize);
            this.endingRecord = this.pageSize;
            this.page = 1;
            this.startingRecord = 1;
        });
    }

    handleSelect(event){
        this.pageSize = event.target.value;
        this.page = 1;
        this.displayRecordPerPage(this.page);
    }

    firstprevioushandler(event){
        this.page = 1;
        this.displayRecordPerPage(this.page);
    }

    previousHandler(event){
        if (this.page > 1) {
            this.page = this.page - 1; //decrease page by 1
            this.displayRecordPerPage(this.page);  
        }
    }
    
    nextHandler(event){
        if((this.page<this.totalPage) && this.page !== this.totalPage && this.totalRecountCount > this.endingRecord){
            this.page = this.page + 1;  
            this.displayRecordPerPage(this.page);  
        }
    }

    lastnexthandler(event){
        if( this.totalRecountCount > this.endingRecord){
            this.page = this.totalPage;
            this.displayRecordPerPage(this.page);  
        }
    }

    displayRecordPerPage(page){
        this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); 
        this.startingRecord = ((page -1) * this.pageSize);
        this.endingRecord = (this.pageSize * page);
        this.endingRecord = (this.endingRecord > this.totalRecountCount) ? this.totalRecountCount : this.endingRecord;

        this.gridData = this.data.slice(this.startingRecord+1, this.endingRecord);
        this.startingRecord = this.startingRecord + 1;
    }
}