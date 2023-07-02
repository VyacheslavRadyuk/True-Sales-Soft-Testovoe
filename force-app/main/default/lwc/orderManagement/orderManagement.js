import { LightningElement, api, wire, track } from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import initData from '@salesforce/apex/OrderManagementController.getInitData';
import createProduct from '@salesforce/apex/OrderManagementController.createProduct';
import PRODUCT_OBJECT from '@salesforce/schema/Product__c';
import NAME_FIELD from '@salesforce/schema/Product__c.Name';
import TYPE_FIELD from '@salesforce/schema/Product__c.Type__c';
import FAMILY_FIELD from '@salesforce/schema/Product__c.Family__c';
import IMAGE_FIELD from '@salesforce/schema/Product__c.Image__c';
import DESCRIPTION_FIELD from '@salesforce/schema/Product__c.Description__c';

export default class OrderManagement extends NavigationMixin(LightningElement) {
    productObject = PRODUCT_OBJECT;
    nameField = NAME_FIELD;
    nameFieldValue;
    typeField = TYPE_FIELD;
    typeFieldValue;
    familyField = FAMILY_FIELD;
    familyFieldValue;
    imageField = IMAGE_FIELD;
    imageFieldValue;
    descriptionField = DESCRIPTION_FIELD;
    descriptionFieldValue;
    searchValue = '';
    searchByType = '';
    searchByFamily = '';
    productDetailsId = '';
    productsToCart = [];
    @api refRecordId;
    @track account;
    @track products;
    @track productTypes;
    @track productFamilies;
    @track isManager;
    @track isModalCreateProduct = false;
    @track isModalDetails = false;

    get isDisabledButton() {
        return !this.isManager;
    }

    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        if (currentPageReference.state.c__refRecordId) {
            this.refRecordId = currentPageReference.state.c__refRecordId;
        }
    }

    @wire(initData, {recordId : '$refRecordId', searchValue : '$searchValue', productType : '$searchByType', productFamily : '$searchByFamily'})  
    wiredInitData({error, data}) {
        if(data) {
            this.account = data.currentAccount;
            this.isManager = data.isManager;
            this.products = data.products;
            this.productTypes = data.productTypes;
            this.productFamilies = data.productFamilies;
        } else if (error) {
            console.log(error);
        }
    }

    openModal() {
        this.isModalCreateProduct = true;
    }

    closeModal() {
        this.isModalCreateProduct = false;
    }

    openModalProductDetails(event) {
        this.productDetailsId = event.currentTarget.dataset.productid;
        this.isModalDetails = true;
    }

    closeModalProductDetails() {
        this.productDetailsId = '';
        this.isModalDetails = false;
    }

    createProduct() {
        createProduct({productName: this.nameFieldValue, productType: this.typeFieldValue, productDescription: this.descriptionFieldValue, productFamily: this.familyFieldValue, productImage: this.imageFieldValue})
        .then(result => {
        })
        .catch(error => {
            this.error = error;
            console.error(error.body.message);
        });
        this.nameFieldValue = '';
        this.typeFieldValue = '';
        this.familyFieldValue = '';
        this.descriptionFieldValue = '';
        this.imageFieldValue = '';
        this.isModalCreateProduct = false;
    }

    handleChangeFieldName(event) {
        this.nameFieldValue = event.target.value;
    }

    handleChangeFieldType(event) {
        this.typeFieldValue = event.target.value;
    }

    handleChangeFieldFamily(event) {
        this.familyFieldValue = event.target.value;
    }

    handleChangeFieldImage(event) {
        this.imageFieldValue = event.target.value;
    }

    handleChangeFieldDescription(event) {
        this.descriptionFieldValue = event.target.value;
    }

    handleChangeSearch(event) {
        this.searchValue = event.target.value;
    }

    handleChangeType(event) {
        if (this.searchByType === event.currentTarget.innerHTML) {
            this.searchByType = '';
        } else {
            this.searchByType = event.currentTarget.innerHTML;
        }
        console.log(this.searchByType);      
    }

    handleChangeFamily(event) {
        if (this.searchByFamily === event.currentTarget.innerHTML) {
            this.searchByFamily = '';
        } else {
            this.searchByFamily = event.currentTarget.innerHTML;
        }
        console.log(this.searchByFamily);
    }

    addProductToCart(event) {
        let newProductToCartFound = true;
        if(this.productsToCart.length == 0) {
            this.productsToCart.push({
                id : event.currentTarget.dataset.productid,
                name : event.currentTarget.dataset.productname,
                size : 1
            });
        } else {
            let newProductToCartFound = true;
            this.productsToCart.forEach((eachEle, index, array) => {
                if (JSON.stringify(eachEle.id) === JSON.stringify(event.currentTarget.dataset.productid)) {
                    eachEle.size += 1;
                    newProductToCartFound = false;
                }
            });
            if (newProductToCartFound) {
                this.productsToCart.push({
                    id : event.currentTarget.dataset.productid,
                    name : event.currentTarget.dataset.productname,
                    size : 1
                });
            }
        }
        console.log(JSON.parse(JSON.stringify(this.productsToCart)));
    }
}