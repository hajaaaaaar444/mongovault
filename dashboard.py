import streamlit as st
import pandas as pd
import json
import os

# --- PAGE CONFIGURATION ---
st.set_page_config(page_title="MongoDB Backup Monitor", page_icon="🛡️", layout="wide")
st.title("🛡️ MongoDB Backup Command Center")

# --- LOAD DATA ---
log_file = "/home/ubuntu/backup_metrics.json"

if not os.path.exists(log_file):
    st.error(f" Log file not found at {log_file}. Run your backup script first!")
else:
    data = []
    # Read the file line by line
    with open(log_file, 'r') as f:
        for line in f:
            try:
                data.append(json.loads(line))
            except json.JSONDecodeError:
                continue
    
    if not data:
        st.warning("File exists but is empty.")
    else:
        # Convert to a Table (DataFrame)
        df = pd.read_json(json.dumps(data))
        df['timestamp'] = pd.to_datetime(df['timestamp'])

        # --- KEY METRICS (Top Row) ---
        latest = df.iloc[-1] # Get the most recent backup
        
        col1, col2, col3 = st.columns(3)
        
        # 1. STATUS
        if latest['status'] == "Success":
            col1.metric("Latest Status", "✅ Success")
        else:
            col1.metric("Latest Status", "❌ Failed")
            
        # 2. SIZE (Converted to KB)
        size_kb = latest['size_bytes'] / 1024
        col2.metric("Backup Size", f"{size_kb:.2f} KB")
        
        # 3. TIME
        col3.metric("Last Run", str(latest['timestamp']))

        st.divider()

        # --- CHARTS ---
        c1, c2 = st.columns(2)
        
        with c1:
            st.subheader(" Size Trend (Bytes)")
            st.line_chart(df, x="timestamp", y="size_bytes")
            
        with c2:
            st.subheader("duration (Seconds)")
            st.bar_chart(df, x="timestamp", y="duration_seconds")

        # --- RAW DATA ---
        with st.expander("View Full Logs"):
            st.dataframe(df.sort_values(by="timestamp", ascending=False))
            
    # Refresh Button
    if st.button(' Refresh Data'):
        st.rerun()
