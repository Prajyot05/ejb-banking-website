# EJB Banking Web Application (Assignment)

This project demonstrates a full **business interface + business logic implementation using EJB** for a web application.

## Assignment Requirement Coverage

- Business interface designed: `BankingService` (EJB Local interface)
- Business logic implemented in EJB: `BankingServiceBean`
- Transaction operations implemented:
  - Account creation
  - Deposit
  - Withdraw
  - Balance inquiry
  - Transaction history
- Validation and exception handling:
  - Invalid account id
  - Invalid amount
  - Duplicate account
  - Account not found
  - Insufficient funds
- Web layer integrated with EJB using servlets + JSP

## Tech Stack

- Jakarta EE 10 (EJB, Servlet, JSP)
- Maven (WAR packaging)
- In-memory account store with EJB-managed concurrency (`@Singleton`, `@Lock`)

## Project Structure

- `src/main/java/com/wtmini/bank/business` - EJB business interface and stateless bean
- `src/main/java/com/wtmini/bank/store` - Singleton state and transaction operations
- `src/main/java/com/wtmini/bank/web` - Servlet controllers
- `src/main/java/com/wtmini/bank/exception` - Custom business exceptions
- `src/main/java/com/wtmini/bank/model` - DTO and transaction models
- `src/main/webapp` - JSP pages

## Build

Run in project directory:

```bash
mvn clean package
```

WAR output:

- `target/ejb-banking-app.war`

## Deploy

Deploy the generated WAR to any Jakarta EE compatible server (Payara, GlassFish, WildFly with Jakarta EE support).

Example access URL after deployment:

- `http://localhost:8080/ejb-banking-app/transaction`

## Sample Demo Flow (for Viva/Submission)

1. Create account `A1001` with opening deposit `1000`
2. Deposit `500`
3. Withdraw `300`
4. Open history page and show all records with updated balance
5. Try withdrawing very large amount to demonstrate business-rule exception (insufficient funds)

## Key EJB Concepts Demonstrated

- EJB Local Business Interface (`@Local`)
- Stateless Session Bean (`@Stateless`)
- EJB dependency injection (`@EJB`)
- Transaction attributes (`@TransactionAttribute`)
- Singleton bean with container-managed locking (`@Singleton`, `@Lock`)
- Separation of interface, business logic, and web layer

To run use: java -jar payara-micro.jar --deploy target/ejb-banking-app.war --port 8080