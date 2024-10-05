<img src="demo_captures/SAP_2011_logo.svg.png" width="100">

# SAP Interior Construction Quotation Applications

**Demonstration Video:** [https://youtu.be/dMY6Nq3g0ts](https://youtu.be/dMY6Nq3g0ts)

# 1. Requirements:

- **_Application name:_** Domus - SAP Interior Construction Quotation Applications.

- **_Purpose:_**

  - Domus helps customers create quotations through customizable packages (including products and services), supporting transparent negotiations between customers and staff, and providing a system of procedures until final contracts are created and signed. Especially, staff and customers could review the previous edited versions of quotations.

- **_Features:_**

  - **Staff:**

    - Manage packages
    - Manage quotations
    - Negotiate with customers
    - Manage contracts

  - **Customers:**

    - View packages
    - Customize packages
    - Request quotations
    - View quotations and quotation versions
    - Feedback quotations
    - Accept quotations
    - Cancel quotations
    - View contracts
    - Sign contracts

  - **Admin:**

    - View dashboard
    - Assign requested-quotations for staff

---

# 2. Demonstration:

- ## Scenario 01:

<img src="demo_captures/Scenario01.png">

1. **Fiori Launchpad Home Page:**![Alt text](demo_captures/2.png)
2. **View package list (Staff):**![Alt text](demo_captures/8.png)
3. **Create new package (Staff):**![Alt text](demo_captures/48.png)
4. **Browse package list (Customer):**![Alt text](demo_captures/58.png)
5. **Customize one package (Customer):**![Alt text](demo_captures/61.png)
6. **View quotation list (Customer):**![Alt text](demo_captures/64.png)
7. **View quotation detail (Customer):**![Alt text](demo_captures/68.png)

- ## Scenario 02:

<img src="demo_captures/Scenario02.png">
<img src="demo_captures/Scenario02(1).png">

1. **Assign the quotation to one staff (Admin):**![Alt text](demo_captures/74.png)
2. **Update the assigned quotation(Staff):**![Alt text](demo_captures/92.png)
3. **View different quotation versions (Staff):**![Alt text](demo_captures/93.png)
4. **Accept the quotation (Customer):**![Alt text](demo_captures/100.png)
   ![Alt text](demo_captures/101.png)
5. **Negotiation (Customer and Staff):**![Alt text](<demo_captures/101(1).png>)
6. **Make contract (Staff):**
   - View the accepted quotation: ![Alt text](demo_captures/104.png)
   - Write the contract description: ![Alt text](demo_captures/106.png)
     ![Alt text](demo_captures/107.png)
   - Automatically send message to the customer: ![Alt text](<demo_captures/108(1).png>)

- ## Scenario 03:

<img src="demo_captures/Scenario03.png">

1. **Sign Contract (Customer):**
   - Contract **before** being signed: ![Alt text](<demo_captures/112(2).png>)
   - Contract **after** being signed: ![Alt text](demo_captures/114.png)
2. **View dashboard (Admin):**![Alt text](demo_captures/136.png)

---

# 3. Database design:

- **Conceptual ERD:**
  ![Alt text](demo_captures/ConceptualERD.png)
- **Logical ERD:**
  ![Alt text](demo_captures/LogicalERD.png)

---

# 4. Launchpad Designer:

- **_Technical Catalogs:_**

  - **Tiles:** ![Alt text](demo_captures/121.png)
  - **Target Mappings:** ![Alt text](demo_captures/123.png)

- **_Business Catalogs:_**

  - **Customer:** ![Alt text](demo_captures/127.png)
  - **Staff:** ![Alt text](demo_captures/124.png)
  - **Admin:** ![Alt text](demo_captures/130.png)

- **_Groups:_**

  - **Customer:** ![Alt text](demo_captures/134.png)
  - **Staff:** ![Alt text](demo_captures/133.png)
  - **Admin:** ![Alt text](demo_captures/135.png)

- **Result:**
  - **_Fiori Launchpad Home Page:_**![Alt text](demo_captures/2.png)

---

# 5. Tech Stack:

- DYNPRO, Table Control, Custom Control, Tabstrip, ALV, Message Class, RAP, Draft Scenario, Target Mapping using Launchpad Designer, Fiori Overview Page (Analytical Apps)
