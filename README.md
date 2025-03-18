# dbt
A tool for transforming data within a data warehouse, responsible for the "T" in ELT (Extract, Load, Transform).
Data warehouses include modern data platforms such as Snowflake, Redshift, BigQuery, and Databricks.

# Why Choose dbt?
* **Open Source and Cost-Effective:** dbt is free to use, making it accessible for teams of all sizes.
* **SQL-Based:** Users can leverage their existing SQL knowledge, eliminating the need for specialized programming skills.
* **Optimized for Modern Cloud Data Platforms:** dbt is designed to work seamlessly with platforms like Snowflake, Redshift, BigQuery, and Databricks.
* **Essential Features:** Includes Version Control for tracking changes, Automated Testing to ensure data quality, Documentation Generation for easy reference, and Data Lineage Visualization for understanding data flow.
* **Enhances Team Collaboration:** Provides a unified environment for coding, testing, documenting, and deploying data transformations, fostering teamwork and efficiency.

# ETL vs ELT
* **ETL (extract transform load)** is the process of creating new database objects by extracting data from multiple data sources, transforming it on a local or third party machine, and loading the transformed data into a data warehouse.
* **ELT (extract load transform)** is a more recent process of creating new database objects by first extracting and loading raw data into a data warehouse and then transforming that data directly in the warehouse.
* The new ELT process is made possible by the introduction of cloud-based data warehouse technologies.

# Why Shift from ETL to ELT
* **Cost-effective:** ELT reduces costs by minimizing the need for complex transformations before data loading, allowing for more efficient use of resources.
* **Scalability:** ELT processes can easily scale with the growth of data, leveraging the power of modern data warehouses to handle large volumes of information.
* **Flexibility:** ELT allows for on-the-fly transformations, enabling users to adapt to changing business needs without extensive rework.
* **Faster time-to-insight:** By loading raw data first, organizations can quickly access and analyze data, leading to faster decision-making.
* **Improved Data Governance:** ELT enhances data governance by maintaining raw data in its original form, allowing for better tracking, auditing, and compliance.

# Traditional Data Team vs Modern Data Team
Traditional Data Team
* **Data engineers** are responsible for maintaining data infrastructure and the ETL process for creating tables and views.
* **Data analysts** focus on querying tables and views to drive business insights for stakeholders.

Modern Data Team
* **Data Engineer:** Focuses on extracting and loading raw data into the DWH and larger Data Infrastructure (EL).
* **Analytics Engineer:** Bridges the gap between data engineering and data analysis, responsible for transforming raw data into a format that is accessible and useful for analysis, ensuring data quality and consistency. Responsible for the Transformation of the raw data up to the BI layers (T).
* **Data Analyst:**  focus on insight and dashboard work using the transformed data.

Note: At a small company, a data team of one may own all three of these roles and responsibilities. As your team grows, the lines between these roles will remain blurry.

# Cloud-based Data Warehouse
**Cloud-based Data Warehouse (DWH)** combines the functionalities of traditional databases with the scalability and flexibility of cloud computing. This integration facilitates efficient data storage, processing, and transformation, allowing organizations to manage large datasets effortlessly. Key benefits include a scalable compute engine, enhanced storage capabilities, and reduced data transfer times. Data can be transformed directly within the database, eliminating the need for repetitive extraction and loading processes. This approach signifies a transition to ELT (Extract, Load, Transform), where data is first loaded into the DWH and then transformed as needed.

# Modern Data Stack and dbt
* **Source Data:** Various sources including Customer Relationship Management (CRM) systems, Salesforce for sales data, and HubSpot for marketing data, providing a comprehensive view of customer interactions and business performance.
* **Data Platforms:** Leading cloud data warehouses such as Snowflake, BigQuery, and Redshift, all of which are fully supported by dbt Cloud, enabling seamless integration and efficient data management.
* **Extract and Load Tools:** Tools like Fivetran for automated data extraction and loading, Stitch for data integration, and Apache Airflow for orchestrating complex data workflows, ensuring that data is consistently and reliably ingested into the data warehouse.
* **dbt (Transform):** A powerful tool that works in conjunction with data platforms to facilitate the transformation of raw data. It offers features for testing data integrity, generating documentation for data models, and deploying transformations. Key functionalities include dbt Directed Acyclic Graphs (DAGs) that visualize data lineage, helping teams understand the flow of data through various transformations.
* **Business Intelligence Tools:** Popular BI tools such as Tableau, Looker, and Mode that allow users to create interactive dashboards and reports, enabling data-driven decision-making across the organization.
* **Machine Learning Models:** Utilization of Jupyter Notebooks and Python scripts for developing and deploying machine learning models, allowing data scientists to analyze data, build predictive models, and derive insights from large datasets.
* **Operational Analytics:** Focus on providing real-time data insights and reporting capabilities, enabling organizations to monitor key performance indicators (KPIs) and make informed decisions based on the latest data trends.

# dbt components
* **DAGs (Directed Acyclic Graphs):**
  - Visual representation of the workflow of data transformations.
  - Helps in viewing the lineage graph, showing how data flows through various transformations.
  - DAGs are created for the entire dbt project, providing a comprehensive overview of dependencies and execution order.

* **Sources:**
  - Represented in green within the data platform.
  - Tables that are ingested from EL tools such as Fivetran and Python scripts.
  - Serve as the foundational data inputs for models.
* **Models:**
  - Represented in blue within the data platform.
  - Each model corresponds one-to-one with a table or view in the data platform.
  - Models can be persisted into the data platform, allowing for further analysis and reporting.
* **Tests:**
  - Configuration of YML files is required to set up tests for data quality.
  - Tests help ensure that the transformations produce the expected results and maintain data integrity.
* **Documentation:**
  - dbt allows for automatic generation of documentation for data models.
  - Documentation can be viewed through a dedicated site, providing easy access to model descriptions and usage.

# References, command, and deployment
* **References (ref):**
  - Used for referencing dependencies between models.
  - Ensures that changes in one model are reflected in dependent models, maintaining data integrity.
* **Commands:**
  - `dbt run`: Executes the transformations defined in the models.
  - `dbt test`: Runs the tests defined in the YML files to validate data quality.
  - `dbt build`: Compiles and builds the models, preparing them for execution.
  - `dbt docs generate`: Generates the documentation site for the project, allowing users to view and navigate through the documentation.
* **Deployment:**
  - Set up different environments (e.g., development, production) for managing dbt projects.
  - Jobs can be scheduled to run daily, executing a set of commands at specified intervals to keep data up-to-date.
