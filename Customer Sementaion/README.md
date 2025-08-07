# Mall Customers Segmentation using K-Means Clustering

This project performs customer segmentation using **K-Means Clustering** on a mall customers dataset. The aim is to categorize customers into distinct groups based on their spending patterns and annual income, enabling businesses to better target their services.

## 📁 Dataset

The dataset used is `Mall_Customers.csv`, which contains the following fields:

- **CustomerID**
- **Gender**
- **Age**
- **Annual Income (k$)**
- **Spending Score (1-100)**

## 📊 Objective

To segment customers into groups using clustering, especially K-Means, and visualize the patterns among different customer groups. This helps in customer profiling and targeted marketing strategies.

## 🛠️ Technologies Used

- Python
- Pandas
- NumPy
- Matplotlib
- Seaborn
- Scikit-learn

## 📌 Main Steps

1. **Data Loading & Preprocessing**
   - Load CSV data into a pandas DataFrame
   - Initial data inspection with `.head()`, `.info()`, `.describe()`

2. **Exploratory Data Analysis (EDA)**
   - Distribution plots for gender, age, annual income, and spending score
   - Pairplots and correlation heatmaps

3. **Clustering with K-Means**
   - Elbow Method to determine optimal number of clusters
   - Apply K-Means Clustering using scikit-learn
   - Visualize clusters using scatter plots

## 📈 Output

- Customer segments visualized in a 2D plot (Annual Income vs Spending Score)
- Elbow plot showing the optimal number of clusters

## 🚀 How to Run

1. Clone the repository or download the notebook.
2. Install required libraries:
   ```bash
   pip install pandas numpy matplotlib seaborn scikit-learn
