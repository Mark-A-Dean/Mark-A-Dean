# The BISL Resource Inventory Use Case

**Contents**  

- [Introduction](#introduction)
- [Diagram](#diagram)
  - [Elements](#elements)
- [Examples](#examples)
- [See Also](#see-also)
- [Acronyms](#acronyms)

## Introduction

A UML Use Diagram generalizes the complex process of the **BISL Resource Inventory Program** by showing where persons or external systems interact with it and its basic process flow. Diagramming elements are described in this article, but the importance of the diagram remains illustrative. This diagram does not show the specific ways in which the internal processes are conducted.

Unless otherwise specified, *system* replaces the name of the BISL Resource Inventory Program much like *program* or *Inventory*—when capitalized, may be similarly used.

The term _data_ is used in place of "unprocessed, potentially informative objects". This replacement can then apply to the specific objects commonly regarded as being data and also the metadata that describe the objects themselves.

## Diagram

![bisl-resource-inventory-use-case-diagram](https://github.com/department-of-veterans-affairs/CDWNG-CustomerEngagement-Inventory/blob/master/images/bisl_resource_inventory_use_case_diagram.jpg "BISL Resource Inventory UML Use Case Diagram")

### Elements

**Actor**  
A person or an external system that interacts with the system; also *subject*.  

**Association**  
The indication that an actor and a Use Case somehow interact or communicate.

**\<\<extend>>**  
A conditional relationship between two Use Cases where the behavior of the extending case is inserted into the behavior of the other based on a Use Case definition.

**Generalization**  
A relationship that signifies a diagram elements (or a set of diagram elements) requires other diagram elements for an implementation or a specification; also *Dependency*.

**\<\<include>>**  
A relationship of requirement between two Use Cases whereby the behavior of the included case is inserted into the behavior of the other.

**System**  
A physical system or the general context of Use Cases.

**Use Case**  
A specification of a set of actions performed by a system that yields an observable result, which is typically the value for one or more actors of the system.

## Examples

- A primary stakeholder asks that a set of data be inventoried and provides the basic functional requirements.
- A data set is stored in some medium or format.
- An auditing process accesses stored Inventory data to assess compliancy with a set of business standards.
- A report developer opens a PowerBI report to find the DOEx data table with the highest number of subscriptions.
- A new customer to the CDW opens a PowerBI report to find who they contact to join a CDW Workgroup.
- A BISL CDW technical team reviews an error log to locate which databases were deadlocked at a specific point in time.

## See Also

[BISL Resource Inventory Use Case Itemization](https://github.com/department-of-veterans-affairs/CDWNG-CustomerEngagement-Inventory/blob/master/documents/about_bisl_resource_inventory_use_case.md)

## Acronyms

**BISL**: Business Intelligence Service Line  
**CDW**: Corporate Data Warehouse  
**DOEx**: Data Object Exchange  
**UML**: Unified Modeling Language
