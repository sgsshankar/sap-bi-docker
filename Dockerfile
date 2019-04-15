#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES # OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE # LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR 
# IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

FROM hjd48/redhat

LABEL author="sgsshankar" \
      install="SAP Business Objects" \
      platform="Redhat Linux" \
      license="Apache 2.0" \
      description="Docker file for SAP Business Objects" \
      terms="Use at your own risk. No Warranty or Guarantee provided. This is not endorsed by my Employer"

# Install Variables
ENV sourcepath=/source
ENV installpath=/usr/sap/bobj
ENV bobjlanguage=en
ENV tomcatport=8080
ENV bobjlicensekey=00000-0000000-0000000-0000
ENV bobjcmsport=6401
ENV databasetype=Oracle
ENV databaseuser=dbuser
ENV databasepwd=dbpasswd
ENV dbservice=bobjsrv
ENV bobjtomcatport=8080
ENV bobjtomcatredir=8443
ENV bobjtomcatshut=8005

# Prerequisite
ENV LANG=en_US.utf8
ENV LC_ALL=en_US.utf8
CMD yum install libstdc++.i686,libstdc++.x86_64,compat-libstdc++-33.i686,compat-libstdc++-33.x86_64,glibc.i686,glibc.x86_64,libX11.i686,libX11.x86_64,libXext.i686,libXext.x86_64,expat.i686,expat.x86_64,libgcc.i686,libgcc.x86_64,libXcursor.i686
RUN mkdir $installpath

RUN service iptables stop
RUN chkconfig iptables off

# Ports
EXPOSE 8080 6400 6405

# Copy Source files into the Image
ADD source/ $sourcepath

# Trigger the installation
WORKDIR $sourcepath
RUN ./install -s $sourcepath -c $bobjlanguage -INSTALLDIR $installpath -BOBJELICENSEKEY $bobjlicensekey -INSTALLTYPE new -BOBJEINSTALLLOCAL user -CMSPORTNUMBER $bobjcmdport -DBTYPE $databasetype -SERVICENAME $dbservice -DATABASEUID $databaseuser -DATABASEPWD $databasepwd -REINIT yes -INSTALLTOMCAT yes -TOMCATCONNECTORPORT $bobjtomcatport -TOMCATREDIRECTPORT $bobjtomcatredir -TOMCATSHUTDOWNPORT $bobjtomcatshut -REINIT yes

# Start the BOBJ Services
WORKDIR $installpath/bobje
CMD ./ccm.sh -start all
CMD ./ccm.sh -enable all