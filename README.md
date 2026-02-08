# Brazilian E-commerce KPI Dashboard 📊

![Dashboard](https://img.shields.io/badge/Download%20Latest%20Release-Click%20Here-blue.svg)

Welcome to the Brazilian E-commerce KPI Dashboard repository! This project presents a lightweight dashboard that transforms the open-source Brazilian Olist dataset into a concise, one-page dashboard. 

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Technologies Used](#technologies-used)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Data Sources](#data-sources)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Overview

This dashboard provides a clear view of key performance indicators (KPIs) for e-commerce. It utilizes MySQL 8 for data extraction, transformation, and loading (ETL), along with feature derivation and window-function KPIs. Tableau handles the visualization, allowing users to drill down into revenue, orders, returns, categories, and states. The entire setup can be reproduced with just two shell commands and requires only 20 MB of CSV files.

For the latest release, visit [here](https://github.com/azgra/Brazilian-E-commerce-KPI-Dashboard-/releases).

## Features

- **Lightweight Design**: The dashboard is designed to be efficient and user-friendly.
- **Comprehensive KPIs**: View essential metrics for e-commerce performance.
- **Drill-Down Capabilities**: Analyze data by revenue, orders, returns, categories, and states.
- **Easy Setup**: Reproduce the dashboard with two simple shell commands.
- **Open-Source Data**: Utilizes the Brazilian Olist dataset for real-world insights.

## Technologies Used

- **MySQL 8**: For handling ETL processes and SQL queries.
- **Tableau**: For data visualization and dashboard creation.
- **CSV Files**: Data is stored in compact CSV format for easy access and manipulation.

## Getting Started

To set up the Brazilian E-commerce KPI Dashboard, follow these steps:

1. **Clone the Repository**: Use the following command to clone the repository to your local machine.

   ```bash
   git clone https://github.com/azgra/Brazilian-E-commerce-KPI-Dashboard-.git
   ```

2. **Navigate to the Directory**: Change into the project directory.

   ```bash
   cd Brazilian-E-commerce-KPI-Dashboard-
   ```

3. **Run the Shell Commands**: Execute the two shell commands provided in the repository to set up the environment.

   ```bash
   ./setup_command_1.sh
   ./setup_command_2.sh
   ```

## Usage

Once the setup is complete, you can access the dashboard through Tableau. Open Tableau and connect to the data source to start exploring the KPIs.

1. **Open Tableau**: Launch Tableau on your machine.
2. **Connect to Data**: Select the MySQL database and enter your connection details.
3. **Explore the Dashboard**: Use the interactive features to analyze different aspects of the e-commerce data.

For more details, check the [Releases](https://github.com/azgra/Brazilian-E-commerce-KPI-Dashboard-/releases) section for any updates or changes.

## Data Sources

The data used in this project comes from the open-source Brazilian Olist dataset available on Kaggle. This dataset contains comprehensive information about e-commerce transactions in Brazil, making it ideal for analysis.

### Dataset Features

- **Order ID**: Unique identifier for each order.
- **Customer ID**: Unique identifier for each customer.
- **Product ID**: Unique identifier for each product.
- **Order Date**: Date when the order was placed.
- **Return Status**: Indicates whether the order was returned.

## Contributing

We welcome contributions to improve the Brazilian E-commerce KPI Dashboard. If you would like to contribute, please follow these steps:

1. **Fork the Repository**: Create a personal copy of the repository on your GitHub account.
2. **Create a Branch**: Use a descriptive name for your branch.

   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make Changes**: Implement your changes or add new features.
4. **Commit Your Changes**: Commit your changes with a clear message.

   ```bash
   git commit -m "Add your message here"
   ```

5. **Push to Your Fork**: Push your changes to your forked repository.

   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create a Pull Request**: Open a pull request to merge your changes into the main repository.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For questions or feedback, feel free to reach out:

- **Email**: your.email@example.com
- **GitHub**: [azgra](https://github.com/azgra)

For the latest release, check out [this link](https://github.com/azgra/Brazilian-E-commerce-KPI-Dashboard-/releases).