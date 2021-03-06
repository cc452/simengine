import React from 'react';
import PropTypes from 'prop-types';
import { withStyles } from '@material-ui/core/styles';
import Card from '@material-ui/core/Card';
import CardContent from '@material-ui/core/CardContent';
import CardHeader from '@material-ui/core/CardHeader';
import Divider from '@material-ui/core/Divider';
import Typography from '@material-ui/core/Typography';
import Switch from '@material-ui/core/Switch';
import FormControlLabel from '@material-ui/core/FormControlLabel';

const styles = {
  card: {
    minWidth: 320,
    position: 'absolute',
    top: 90,
    right: 20,
  },
  bullet: {
    display: 'inline-block',
    margin: '0 2px',
    transform: 'scale(0.8)',
  },
  title: {
    marginBottom: 16,
    fontSize: 14,
  },
  pos: {
    marginBottom: 12,
  },
};

function SimpleCard(props) {
  const { classes, assetInfo, assetKey, changeStatus } = props;
  let children = [];

  if(assetInfo.children) {
    children.push(
      <div><h3> Connected Components </h3></div>
    );

    const c = assetInfo.children;
    for (const ckey of Object.keys(c)) {
        children.push(
        <div key={ckey}>
            <Typography variant="subheading" component="h5">
              Nested Asset: {ckey}-{c[ckey].type}
            </Typography>
                <Typography component="p">
                  ::Status-{c[ckey].status === 1?<span style={{color: 'green'}}>on</span>:<span style={{color: 'red'}}>off</span>}
                </Typography>
          </div>
        );
    }
  }

  return (
    <div>
      <Card className={classes.card}>
        <CardHeader
          title="Selected Asset Details"
          style={{ backgroundColor: '#e1e6ea' }}
        />
        <CardContent>
          <Typography variant="headline" component="h2">
            Asset: {assetKey}-{assetInfo.type}
          </Typography>
          <Typography component="p">
            Status: {assetInfo.status === 1?<span style={{color: 'green'}}>on</span>:<span style={{color: 'red'}}>off</span>}
          </Typography>

          <Typography component="p">
            Current Load: {assetInfo.load ? assetInfo.load.toFixed(2): 0}
          </Typography>



          <Divider />
            {/* Turn off/on the component */}
            <FormControlLabel
              control={<Switch checked={assetInfo.status} aria-label="LoginSwitch" onChange={()=>changeStatus(assetKey, assetInfo)}/>}
              label={"Toggle Status"}
            />
          <Divider/>
          {/* Display any nested elements */}
          {children}
        </CardContent>
        {/*
        <CardActions>
          <Button size="small">Learn More</Button>
        </CardActions>
        */}
      </Card>
    </div>
  );
}

SimpleCard.propTypes = {
  classes: PropTypes.object.isRequired,
  assetInfo: PropTypes.object.isRequired,
  assetKey: PropTypes.object.isRequired,
  changeStatus: PropTypes.func.isRequired, // Change asset state
};

export default withStyles(styles)(SimpleCard);
